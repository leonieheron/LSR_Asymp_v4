
#Question 1

#download data
# get the data directly from redcap:
# report #155 is Q1:

url <- "https://redcap.ispm.unibe.ch/api/"
token <- "################################"
formDataQ1 <- list("token"=token,
                 content='report',
                 format='csv',
                 report_id='155',
                 csvDelimiter='',
                 rawOrLabel='raw',
                 rawOrLabelHeaders='raw',
                 exportCheckboxLabel='false',
                 returnFormat='csv'
)



#subgroup analysis for rob

#download data
# get the data directly from redcap:
# report #155 is Q1:

formDataSubgroup <- list("token"=token,
                 content='report',
                 format='csv',
                 report_id='155',
                 csvDelimiter='',
                 rawOrLabel='raw',
                 rawOrLabelHeaders='raw',
                 exportCheckboxLabel='false',
                 returnFormat='csv'
)

# get the data directly from REDCap: 
# report #171 is Q2:
url <- "https://redcap.ispm.unibe.ch/api/"
token <- "####################################"
formDataQ2 <- list("token"=token,
                   content='report',
                   format='csv',
                   report_id='172',
                   csvDelimiter='',
                   rawOrLabel='raw',
                   rawOrLabelHeaders='raw',
                   exportCheckboxLabel='false',
                   returnFormat='json'
)


# get the data directly from REDCap: 
# report #157 is Q3:

#APIs token is not sharable
token <- "##################################"
formDataQ3 <- list("token"=token,
                    content='report',
                    format='csv',
                    report_id='157',
                    csvDelimiter='',
                    rawOrLabel='raw',
                    rawOrLabelHeaders='raw',
                    exportCheckboxLabel='false',
                    returnFormat='csv'
)


# get the ROB data directly from redcap:
urlrob <- "https://redcap.ispm.unibe.ch/api/"
#APIs token is not sharable

formDatarob <- list("token"=tokenrob,
                    content='report',
                    format='csv',
                    report_id='283',
                    csvDelimiter='',
                    rawOrLabel='raw',
                    rawOrLabelHeaders='raw',
                    exportCheckboxLabel='false',
                    returnFormat='csv'
)
