#call libraries

library(leaflet)
library(gsheet)
library(leaflet.providers)
library(leaflet.extras)
library(crosstalk)
library(htmlwidgets)


# make custom icon
handheart_icon <- makeIcon(
  iconUrl = 'https://www.dropbox.com/s/gbqlhgtrumls5q6/noun-handshake-599923-3E98A2.png?dl=1', #dropbox link containing icon
  iconWidth = 50,     #width of icon
  iconHeight = 50,    #height of icon
  iconAnchorX = 25,    #point of icon as anchor on X-coordinate
  iconAnchorY = 25     #point of icon as anchor on Y-coordinate
)

# import employer data
peer_table <- gsheet2tbl(
  'https://docs.google.com/spreadsheets/d/1sStX8d12t4UCsYrwu6PV91MJIsngYZcXoimMmmTKdaQ/edit?usp=sharing')

# Select Peer Employers
PeerEmp <- ifelse(peer_table$`Peer employers/hire peer specialists` == 'Peer employer', 'Yes', 'No')

# Select Internship Sites
Intern <- ifelse(peer_table$`Internship sites/offers internship hours to peers` == 'Internship site', 'Yes', 'No')

# create geomap
peer_employers <- leaflet(data = peer_table) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addResetMapButton() %>% 
  addMarkers(
    icon = handheart_icon,                      #Add Icon Identifier
    clusterOptions = markerClusterOptions(),        #Change Cluster Options
    popup = as.character(                               #format popup
      paste('<strong>', peer_table$Organization, '</strong>',        #Bold Org Name
            '<br>', peer_table$Street,                                  #Add Address
            '<br>', peer_table$`City, State, Zip`, '<br>',
            ifelse(is.na(peer_table$`Main Phone`) == FALSE,
                   paste('<br>','<strong> Main Phone: </strong>', 
                         paste("<a href='tel:", peer_table$`Main Phone`,"'>", peer_table$`Main Phone`, '</a>')),
                   ''),                   #Add Main Phone and make Clickable
            # ifelse(is.na(peer_table$`Crisis Phone`) == FALSE, 
            #        paste('<br>','<strong> Crisis Phone: </strong>', 
            #              paste("<a href='tel:", peer_table$`Crisis Phone`,"'>", peer_table$`Crisis Phone`, '</a>')),
            #        ''),                   #Add Crisis Phone and make Clickable
            ifelse(is.na(peer_table$`Main Website`) == FALSE, 
                   paste('<br>','<strong> Main Website: </strong>',
                         paste("<a href='", peer_table$`Main Website`,"'>", peer_table$`Main Website`, '</a>')),
                   ''),                            #Add Main Website and make Clickable
            ifelse(is.na(peer_table$`Career Website`) == FALSE, 
                   paste('<br>','<strong> Career Website: </strong>',
                         paste("<a href='", peer_table$`Career Website`,"'>", peer_table$`Career Website`, '</a>')),
                   ''),                            #Add Career Website and make Clickable
            ifelse(PeerEmp == 'Yes', 
                   paste('<br>','<strong> Peer Employer: <font color="#006633"">&#10003;</font> </strong>'),
                   paste('<br>','<strong> Peer Employer: <font color="#DC82C20">X</font> </strong>')),
            ifelse(Intern == 'Yes', 
                   paste('<br>','<strong> Offers Internships: <font color="#006633">&#10003;</font> </strong>'),
                   paste('<br>','<strong> Offers Internships: <font color="#DC82C20">X</font> </strong>')) 
            
      ) 
    )
  )

peer_employers              #Print Geomap

setwd('H:/My Drive/PeerForce_Map/peer-emp-map')

saveWidget(peer_employers, 'peer-emp-map.html', selfcontained = F)

file.remove('H:/My Drive/PeerForce_Map/peer-emp-map/index.html')

file.rename('H:/My Drive/PeerForce_Map/peer-emp-map/peer-emp-map.html', 'H:/My Drive/PeerForce_Map/peer-emp-map/index.html')


