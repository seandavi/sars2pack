#' US hospital dataset
#' 
#' Includes details of beds, NAICS codes, and geolocation data for US states and territories.
#' 
#' This dataset contains locations of Hospitals for 50 US states, Washington D.C., US territories of Puerto Rico, Guam, American Samoa, Northern Mariana Islands, Palau, and Virgin Islands. The dataset only includes hospital facilities based on data acquired from various state departments or federal sources which has been referenced in the SOURCE field. Hospital facilities which do not occur in these sources will be not present in the database. The source data was available in a variety of formats (pdfs, tables, webpages, etc.) which was cleaned and geocoded and then converted into a spatial database. The database does not contain nursing homes or health centers. Hospitals have been categorized into children, chronic disease, critical access, general acute care, long term care, military, psychiatric, rehabilitation, special, and women based on the range of the available values from the various sources after removing similarities. In this update the TRAUMA field was populated for 172 additional hospitals and helipad presence were verified for all hospitals.
#' 
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @source 
#' 
#' - [https://hub.arcgis.com/datasets/geoplatform::hospitals](https://hub.arcgis.com/datasets/geoplatform::hospitals)
#' 
#' @importFrom readr read_csv cols
#' @importFrom sf st_as_sf
#' 
#' @family data-import
#' @family healthcare-systems
#' 
#' @examples 
#' res = us_hospital_details()
#' head(res)
#' colnames(res)
#' summary(res)
#' 
#' 
#' 
#' @export
us_hospital_details = function() {
    url = 'https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = cols())
    colnames(dat) = tolower(colnames(dat))
    dat = st_as_sf(dat, coords = c("longitude", "latitude"), 
                   crs = 4326, agr = "constant")
    dat
}
