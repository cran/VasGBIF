## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)

## ----load-packages,message=FALSE----------------------------------------------
library(rgbif)
library(VasGBIF)
library(dplyr)
library(data.table)

## ----credentials, eval=FALSE--------------------------------------------------
# user  <- "your_username"
# pwd   <- "your_password"
# email <- "your_email@example.com"

## ----name-backbone------------------------------------------------------------
genus <- "Saxifraga"
gbif_key <- name_backbone(genus, rank = "genus")
cat(paste(genus,":",gbif_key$usageKey))

## ----predicates, eval=FALSE---------------------------------------------------
# pred_and(
#   pred("taxonKey", gbif_key$usageKey),
#   pred("basisOfRecord", "PRESERVED_SPECIMEN"),
#   pred("hasCoordinate", TRUE)
# )

## ----occ-download, eval=FALSE-------------------------------------------------
# download <- occ_download(
#   pred("taxonKey", gbif_key$usageKey),
#   pred("basisOfRecord", "PRESERVED_SPECIMEN"),
#   pred("hasCoordinate", TRUE),
#   pred("occurrenceStatus", "PRESENT"),
#   user  = user,
#   pwd   = pwd,
#   email = email,
#   format = 'SIMPLE_CSV'
# )
# 
# download_key <- download$key
# print(download_key)## Building predicates

## ----pred, eval=FALSE---------------------------------------------------------
# ?rgbif::pred

## ----occ-download-wait, eval=FALSE--------------------------------------------
# occ_download_wait(download_key)

## ----occ-download-meta, eval=FALSE--------------------------------------------
# meta <- occ_download_meta(download_key)
# print(meta$status)  # "SUCCEEDED"
# print(meta$doi)      # e.g. "10.15468/dl.xxxxx"## Web download (recommended for very large datasets)

## ----get-records, eval=FALSE--------------------------------------------------
# library(rgbif)
# library(dplyr)
# 
# DOI <- "10.15468/dl.4ty3ap"
# gbif_file <- occ_download_doi(DOI)$key |>
#   occ_download_get(path = tempdir()) |>
#   as.character()

## ----web-download, eval=FALSE-------------------------------------------------
# gbif_file <- "path/to/your/downloaded_file.zip"

## ----import-records, eval=FALSE-----------------------------------------------
# library(VasGBIF)
# library(data.table)
# 
# occ_import <- import_records(path = gbif_file)

