#' Google search trends for COVID-19 and illness-related terms
#'
#' This aggregated, anonymized dataset shows trends in search patterns for symptoms and is intended to help researchers to better understand the impact of COVID-19.
#' Public health experts indicated that trends in search patterns might be helpful in broadly understanding how COVID-19 impacts communities and even in detecting outbreaks earlier. You shouldn’t assume that the data is a recording of real-world clinical events, or use this data for medical diagnostic, prognostic, or treatment purposes.
#'
#' @details
#'
#' This data reflects the volume of Google searches for a broad set of symptoms, signs and health conditions. To keep things simple in this documentation, we will refer to all of these collectively as symptoms. The data covers hundreds of symptoms such as fever, difficulty breathing, and stress—based on the following:
#'
#' - a symptom’s prevalence in Google’s searches
#' - data quality and privacy considerations
#'
#' For each day, we count the searches mapped to each of these symptoms and organize the data by geographic region. The resulting dataset is a daily or weekly time series for each region showing the relative frequency of searches for each symptom.
#'
#' A single search query can be mapped to more than one symptom. For example, we map a search for “acid reflux and coughing up mucus” to three symptoms: Cough, Gastroesophageal reflux disease, and Heartburn.
#'
#' The dataset covers the recent period and we’ll gradually expand its range as part of regular updates. Each update will bring the coverage to within three days of the day of the update.
#'
#' Although we are releasing the dataset in English, we count searches in other languages. In each supported country, we include the languages needed to cover the majority of symptom search queries. For example, in the United States we support Spanish and English.
#'
#' The data represents a sample of our users and might not represent the exact behavior of a wider population.
#'
#' ## Preserving privacy
#'
#' For this dataset, we use differential privacy, which adds artificial noise to our datasets while enabling high quality results without identifying any individual person.
#'
#' To further protect people’s privacy, we ensure that no personal information or individual search queries are included in the dataset, and we don’t link any search-based health inferences to an individual user. More information about the privacy methods used to generate the dataset can be found in this report.
#'
#' ## How we process the data
#'
#' The data shows the relative popularity of symptoms in searches within a geographical region.
#'
#' When the daily volume of the data for a given region does not meet quality or privacy thresholds, we do the following:
#'
#' Try to provide a given symptom at the weekly resolution.
#' If we cannot meet our quality or privacy thresholds at the weekly resolution, we do not provide the data for the symptom in that region.
#' As a result, for a given region, some symptoms will appear exclusively in the daily time series, some exclusively in the weekly time series, and some might not appear at all (if the search data for those symptoms is very scarce).
#'
#' To normalize and scale the daily and the weekly time series (processed separately), we do the following for each region:
#'
#' First, the algorithm counts the number of searches for each symptom in that region for that day/week.
#' Next, we divide this count by the total number of Search users in the region for that day/week to calculate relative popularity (which can be interpreted as the probability that a user in this region will search for the given symptom on that day/week). We refer to this ratio as the normalized popularity of a symptom.
#' We then find the maximum value of the normalized popularity across the entire published time range for that region, over all symptoms using the chosen time resolution (day/week). We scale this maximum value to 100. All the other values are mapped to proportionally smaller values (linear scaling) in the range 0-100.
#' Finally, we store the scaling factor and use it to scale values (for the same region and time resolution) in subsequent releases. In future updates, when a symptom popularity exceeds the previously-observed maximum value (found in step 3), then the new scaled value will be larger than 100.
#' In each region, we scale all the normalized (daily / weekly) popularities using the same scaling factor. In a single region, you can compare the relative popularity of two (or more) symptoms (at the same time resolution) over any time interval. However, you should not compare the values of symptom popularity across regions or time resolutions — the region and time resolution specific scalings make these comparisons meaningless.
#'
#' @param nrows integer(1) passed directly to [data.table::fread()]. Note that
#'   fread treats this as the *maximum* number of rows to read, not the *exact*
#'   number of rows. 
#'
#' @note
#' Use of this dataset implies acceptance of Google's terms of use \url{https://policies.google.com/terms}.
#'
#' @author
#' Sean Davis <seandavi@gmail.com>
#' 
#' @return a data.table
#'
#' @references
#' Google LLC "Google COVID-19 Search Trends symptoms dataset".
#' http://goo.gle/covid19symptomdataset
#'
#' @source
#' \url{https://github.com/GoogleCloudPlatform/covid-19-open-data}
#'
#' @examples
#' \donttest{
#' 
#' # This example loads the dataset which is large. 
#' # Do not expect this example to run without sufficient
#' # memory.
#' \dontrun{
#' res = google_search_trends_data(nrows=1000000)
#'
#' head(res[,1:10])
#' colnames(res)
#' grep('fever',colnames(res))
#' }
#' }
#'
#' @export
google_search_trends_data <- function(nrows=Inf) {
  message("This is a VERY large dataset that may take some time to load \nand requires multiple GB of free RAM to load. \nConsider setting nrows to a smaller value to test first. ")
  url = 'https://storage.googleapis.com/covid19-open-data/v2/index.csv'
  rpath = s2p_cached_url(url)
  idx_data = data.table::fread(rpath,na.strings = '')
  data.table::setkey(idx_data,"key")
  url = "https://storage.googleapis.com/covid19-open-data/v2/google-search-trends.csv"
  rpath = s2p_cached_url(url)
  dset = data.table::fread(rpath,na.strings='', nrows=nrows)
  data.table::setnames(dset, colnames(dset), sub('search_trends_','',colnames(dset)))
  data.table::setkey(dset,"key")
  merge(dset,idx_data,on='key',all.x=FALSE)
}
