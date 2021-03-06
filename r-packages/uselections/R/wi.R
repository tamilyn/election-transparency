#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadWisconsin <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('55') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read.xlsx("data-raw/wi/registeredvotersbycounty_xlsx_13527.xlsx", sheet=1, rows=10:81, cols=c(6,7), colNames=FALSE) %>%
    mutate(CountyName=trimws(gsub(x=X1, pattern='([A-Z]+) COUNTY', replacement='\\1')), N=X2) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
