## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
	echo = TRUE,
	message = FALSE,
	warning = FALSE,eval = F
)

## ----get_records--------------------------------------------------------------
# library(rgbif)
# library(dplyr)
# ## Records can be downloaded with rgbif by DOI without requiring authentication.
# DOI <- "10.15468/dl.4ty3ap"
# gbif_file <- occ_download_doi(DOI)$key %>% occ_download_get(path = tempdir()) %>% as.character()

## ----preparation, message=FALSE-----------------------------------------------
# library(VasGBIF)
# library(data.table)
# 
# # Step 1: Import the download
# occ_import <- import_records(path = gbif_file)
# 
# 
# # Step 2: Resolve taxon names
# taxa_checked <- check_taxon(occ_import = occ_import, accuracy = 0.85)
# 
# # Step 3: Filter records by quality rules
# filtered <- customized_filter(
#   occ_import = occ_import,
#   taxa_checked = taxa_checked
# )
# 
# # Step 4: Validate coordinates
# refined_coordinates <- par_clean_coordinates(
#   input = filtered$occ_filtered,
#   species = 'Accepted_name_id',
#   latitude = 'decimalLatitude',
#   longitude = 'decimalLongitude',
#   threads = 8
# )
# 
# # Step 5: Annotate native status
# native_detected_coord <- detect_native_coord(
#   input = refined_coordinates$CoordinateCleaned,
#   species = 'Accepted_name',
#   latitude = 'decimalLatitude',
#   longitude = 'decimalLongitude'
# )
# 

## ----PAM, message=FALSE-------------------------------------------------------
# library(letsR)
# library(stringi)
# 
# # prepare input for letsR
# PAM_pre <- native_detected_coord[native_status=='native',
#   .(
#     Accepted_name,
#     genus = stri_extract_first_regex(Accepted_name, "^[^ ]+"),
#     family,
#     decimalLongitude,
#     decimalLatitude
#   )
# ]
# 
# head(PAM_pre, 5)
# 
# # Optionally filter to a specific genus or family:
# # PAM_pre <- PAM_pre[genus == "Saxifraga", ]

## ----lets.presab.points-------------------------------------------------------
# PAM <- lets.presab.points(
#   xy      = as.matrix(PAM_pre[, .(decimalLongitude, decimalLatitude)]),
#   species = PAM_pre$Accepted_name,
#   resol   = 1,     # 1-degree grid cells
#   count   = FALSE  # set TRUE for progress bar on large datasets
# )

## ----Statistics---------------------------------------------------------------
# summary(PAM)
# names(PAM)
# PAM$Presence_and_Absence_Matrix[1:10, 1:10] |>
#   as.data.table()
# head(PAM$Species_name)

## ----lets.rangesize-----------------------------------------------------------
# lets.rangesize(x = PAM, units = "cell") |>
#   as.data.frame() |>
#   arrange(desc(Range_size)) |>
#   head(5)

## ----hist---------------------------------------------------------------------
# range_sizes <- lets.rangesize(x = PAM, units = "cell")
# 
# # Mean range size
# mean(range_sizes)
# 
# # Proportion of species exceeding the mean range size
# mean_range <- mean(range_sizes)
# sum(range_sizes > mean_range) / nrow(range_sizes)
# 
# # Histogram of log-transformed range sizes
# hist(
#   log(range_sizes),
#   main = "Distribution of species range sizes",
#   xlab = "log(number of grid cells)"
# )

## ----occ_map------------------------------------------------------------------
# # Replace with any species name from PAM$Species_name
# selected_taxon <- lets.rangesize(x = PAM, units = "cell") |>
#   as.data.frame() |>
#   arrange(desc(Range_size)) |>
#   head(1)%>%row.names()
# plot(PAM,
#      name = selected_taxon,
#      main = paste(selected_taxon, "occurrence"))

## ----PAM_env, message=FALSE, warning=FALSE------------------------------------
# temp <- terra::unwrap(letsR::temp)  # worldclim bio_1: annual mean temperature
# PAM_env <- lets.addvar(PAM, temp, fun = mean)
# 
# # First 5 rows: longitude, latitude, and mean temperature
# PAM_env[1:5, c(1, 2, ncol(PAM_env))]

## ----temp_mean----------------------------------------------------------------
# temp_mean <- lets.summarizer(PAM_env, ncol(PAM_env))
# 
# # Species with the warmest distributions
# temp_mean |>
#   arrange(desc(wc2.1_10m_bio_1_mean)) |>
#   head(5)
# 
# # Species with the coldest distributions
# temp_mean |>
#   arrange(wc2.1_10m_bio_1_mean) |>
#   head(5)

## ----Richness_map-------------------------------------------------------------
# plot(PAM,
#      xlab = "Longitude",
#      ylab = "Latitude",
#      main = "Saxifraga richness map")

