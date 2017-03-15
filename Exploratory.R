# This is for exploring different features of the data

# Want to take a look at the occurrence of certain descriptors and their 
# correlation with the three rankings

# This pulls out all the unique feautres
unique_features <- as.data.frame(unlist(train_data$features), stringsAsFactors = FALSE)
names(unique_features) = "features"
unique_features <- as.data.frame(unique(tolower(unique_features$features)), stringsAsFactors = FALSE)
names(unique_features) = "features"

# Check out the features:
unique_features <- sort(unique_features$features)

# There are some really screwy ones that are very long composed of multiple descriptors
# These are likely unique to a single rental. Ignore these for now, but mayeb use them later
# and look for specific words within longer descriptions for the count total in the 
# eventual feature
 
# The average description is a little shy of 30 characters
mean(nchar(unique_features))

# Manually create a corpus of good words
good_features <- c("24",
                   "free",
                   "laundry",
                   "marble",
                   "sun",
                   "concierge",
                   "lobby",
                   "doorman",
                   "doormen",
                   "fitness",
                   "train",
                   "backyard",
                   "roof",
                   "a/c",
                   "conditioning",
                   "value",
                   "full service",
                   "luxury",
                   "closets",
                   "included",
                   "terrace",
                   "parking",
                   "garage",
                   "billiards",
                   "dishwasher",
                   "balcony",
                   "balconies",
                   "storage",
                   "bbq",
                   "big",
                   "brand new",
                   "hardwood",
                   "built-in",
                   "central",
                   "children",
                   "close",
                   "complimentary",
                   "fireplace",
                   "brick",
                   "gym",
                   "granite"
                   )


bad_features <- c("convertible",
                  "flex",
                  "guarantors",
                  "")
#% MAke sure you didn't duplicate
good_features <- unique(good_features)



# Maybe try counting the most common incidences of a word in each class? no phrases, just the word.
# Build off the unique_features list and break it all out into individual words

# full list of unique words, not full features:
unique_features_words <- unlist(strsplit(unique_features, " "))
unique_features_words <- unique(tolower(unique_features_words))


# Do the same for the description words
unique_description_words <- unlist(strsplit(train_data$description, " "))
unique_description_words <- unique(tolower(unique_description_words))
  
# now count the occurrence of each of these words in the rnakings and see
# if you should include their existence as a new feature.






