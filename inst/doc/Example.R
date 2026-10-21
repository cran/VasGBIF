## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, eval = F)

## ----init---------------------------------------------------------------------
# library(VasGBIF)
# library(data.table)
# VasGBIF_summary <- list()

## ----import_records-----------------------------------------------------------
# gbif_file <- system.file(
#   "extdata", "0003386-260721160103020.zip",
#   package = "VasGBIF"
# )
# occ_import <- import_records(path = gbif_file)
# VasGBIF_summary$initial_records <- nrow(occ_import)
# VasGBIF_summary$initial_taxa <- uniqueN(occ_import$scientificName)
# print(occ_import)

## ----check_taxon--------------------------------------------------------------
# taxa_checked <- check_taxon(occ_import = occ_import, accuracy = 0.85)
# VasGBIF_summary$after_taxon_resolved <- nrow(taxa_checked$occ_taxa_checked)
# VasGBIF_summary$final_taxa <- uniqueN(taxa_checked$occ_taxa_checked$Accepted_name)
# print(taxa_checked)

## ----customized_filter--------------------------------------------------------
# filtered <- customized_filter(
#   occ_import = occ_import,
#   taxa_checked = taxa_checked
# )
# VasGBIF_summary$after_customized_filter <- nrow(filtered$occ_filtered)
# print(filtered)

## ----clean_coordinates--------------------------------------------------------
# cleaned_coordinates <- par_clean_coordinates(
#   input = filtered$occ_filtered,
#   species = 'Accepted_name_id',
#   latitude = 'decimalLatitude',
#   longitude = 'decimalLongitude',
#   threads = 8,tests = c("capitals", "centroids", "equal", "gbif", "institutions", "outliers", "seas", "zeros"))
# VasGBIF_summary$cleaned <- nrow(cleaned_coordinates$CoordinateCleaned)
# VasGBIF_summary$problematic <- nrow(cleaned_coordinates$CoordinateProblematic)
# print(cleaned_coordinates)

## ----detect_native------------------------------------------------------------
# native_detected_coord <- detect_native_coord(
#   input = cleaned_coordinates$CoordinateCleaned,
#   species = 'Accepted_name',
#   latitude = 'decimalLatitude',
#   longitude = 'decimalLongitude', buffer_km = 10, buffer_chunk_size = 2000)
# native_detected_country <- detect_native_country(
#   input = cleaned_coordinates$CoordinateProblematic,
#   country = 'countryCode',
#   species = 'Accepted_name')
# native_detected <- rbind(
#   native_detected_coord,
#   native_detected_country[is.na(decimalLatitude) | is.na(decimalLongitude),],
#   use.names = TRUE,
#   fill = TRUE
# )
# VasGBIF_summary$native <- native_detected[native_status == "native", .N]
# VasGBIF_summary$introduced <- native_detected[native_status == "introduced", .N]
# VasGBIF_summary$extinct <- native_detected[native_status == "extinct", .N]
# VasGBIF_summary$location_doubtful <- native_detected[
#   native_status == "location_doubtful", .N
# ]
# VasGBIF_summary$unknown <- native_detected[native_status == "unknown", .N]
# print(native_detected)

## ----map_records, eval=FALSE--------------------------------------------------
# map_records(
#   native_detected_coord = native_detected_coord,
#   precision = 3,
#   cex = 3
# )

## ----export_records, eval=FALSE, include=T------------------------------------
# export_records(
#   native_detected_coord = native_detected_coord,
#   native_detected_country = native_detected_country,
#   export_path = getwd()
# )

## ----summary------------------------------------------------------------------
# VasGBIF_summary |>
#   as.data.frame() |>
#   t()

