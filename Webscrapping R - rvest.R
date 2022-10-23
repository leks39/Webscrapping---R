#install packages - rvest, dplyr
library(rvest)
library(dplyr)
library(xml2)
library(tibble)

#link = website to be scrapped
link = "https://www.imdb.com/search/title/?count=100&languages=en&num_votes=1000,&sort=num_votes,desc&title_type=tv_series"
page = read_html(link)

#code to scrap title column
title = page %>% html_nodes (".lister-item-header a")%>% html_text()
year = page %>% html_nodes(".text-muted.unbold")%>% html_text()
ratings = page%>% html_nodes ('.ratings-imdb-rating strong')%>% html_text()
genre = page%>% html_nodes(".genre")%>% html_text()

tv_shows = data.frame(title, year, ratings, genre, stringsAsFactors = FALSE)
tv_shows
View(tv_shows)

#set working directory to Source File to save as csv
write.csv(tv_shows, 'tv_shows.csv')

tv_shows2 = data.frame()
#webscrapping multiple pages - figure out the page setting and edit the link

for (page_result in seq(from = 1, to = 5000, by = 100)) {
  link = paste0("https://www.imdb.com/search/title/?title_type=tv_series&num_votes=1000,&languages=en&sort=num_votes,desc&count=100&ref_=",page_result,"&ref_=adv_nxt")
  page = read_html(link)
  title = page %>% html_nodes (".lister-item-header a")%>% html_text()
  year = page %>% html_nodes(".text-muted.unbold")%>% html_text()
  ratings = page%>% html_nodes ('.ratings-imdb-rating strong')%>% html_text()
  genre = page%>% html_nodes(".genre")%>% html_text()
  tv_shows = rbind(tv_shows, data.frame(title, year, ratings, genre, stringsAsFactors = FALSE))
  print(paste("Page:", page_result))
}


View(tv_shows)
write.csv(tv_shows, 'tv_shows.csv')
