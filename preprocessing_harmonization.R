##############################
# Preprocessing of Data
##############################

# Load required libraries and install neuroCombat Rpackage

library(devtools)
library(readr)
library(dplyr)
install_github("jfortin1/neuroCombat_Rpackage")
library(neuroCombat)

# Load and organize data
df_measures <- read_csv("Subcort_Cort.csv")
df_cov <- read_csv("Covariets.csv")
df <- merge.data.frame(df_cov, df_measures, by = "SubjID")

# Exclude missings in covariates of relevance (age, sex, diagnosis)
# and remove duplicates and invalid entries
df_excluded <- df %>%
  filter(!duplicated(SubjID)) %>%
  filter(complete.cases(Age, Dx, Sex)) %>%
  filter(Dx %in% c(0, 1)) %>%
  filter(Sex != "0")

# Exclude participants with >5% missing data across all neuroanatomical domains
ID <- df_excluded$SubjID
all_neuroimaging_output <- df_excluded[, 7:156]
percentage_missings_all <- apply(is.na(all_neuroimaging_output), 1, mean) %>%
  as.data.frame() %>%
  mutate(SubjID = ID)

exclude_missings <- subset(percentage_missings_all, percentage_missings_all >= 0.05)$SubjID
df_excluded <- df_excluded[!df_excluded$SubjID %in% exclude_missings, ]

# Prepare and safe covariate file of remaining participants after exclusion
COV <- df_excluded %>% select(c(1:4, 157:193, 282))
write.csv(COV, "COV.csv")

# Define neuroanatomical measures per domain for harmonization
SV <- data.matrix(df_excluded[, 7:20]) %>% t()  # Subcortical volume
CT <- data.matrix(df_excluded[, 21:88]) %>% t()  # Cortical thickness
CSA <- data.matrix(df_excluded[, 89:156]) %>% t()  # Cortical Surface area

# Transform and prepare covariate data for harmonization
df_excluded <- df_excluded %>%
  mutate(
    Dx = as.factor(Dx),
    Age = as.numeric(Age),
    Sex = as.factor(Sex),
    Site = as.factor(Site)
  )

batch = df_excluded$Site
Age <- df_excluded$Age
Dx <- df_excluded$Dx
Sex <- df_excluded$Sex

#Specifcy model
mod <- model.matrix(~Sex + Dx + Age)

# Harmonize data with neuroComBat
harmonize_data <- function(dat, batch, mod) {
  result <- neuroCombat(dat = dat, batch = batch, mod = mod)$dat.combat
  return(as.data.frame(t(result)))
}

SV_harm <- harmonize_data(SV, batch, mod) %>%
  mutate(SubjID = df_excluded$SubjID) %>%
  relocate(SubjID)

CT_harm <- harmonize_data(CT, batch, mod) %>%
  mutate(SubjID = df_excluded$SubjID) %>%
  relocate(SubjID)

CSA_harm <- harmonize_data(CSA, batch, mod) %>%
  mutate(SubjID = df_excluded$SubjID) %>%
  relocate(SubjID)

# Safe neuroanatomical measures after harmonization

write.csv(SV_harm, "SV_harm.csv")
write.csv(CT_harm, "CT_harm.csv")
write.csv(CSA_harm, "CSA_harm.csv")
