data <- read.csv("articles-TL-20231023.csv", header=TRUE, stringsAsFactors=FALSE)
data$Data.de.submissão <- as.Date(data$Data.de.submissão)
data$Última.alteração <- as.Date(data$Última.alteração)
df <- tail(data[, c("Data.de.submissão", "Última.alteração")], -324)
df$days <- as.integer(df$Última.alteração - df$Data.de.submissão)
df <- na.omit(df)
hist(df$days, breaks = "freedman-diaconis", freq = TRUE, main = "Histograma do tempo para publicação na revista TextoLivre", xlab = "dias", ylab = "frequência")


# echo "field;subfield;subsubfield" > fields.csv
# find /home/leoca/ee/textolivre -type f -name "*.json" | while read file; do jq -r '.field, .subfield, .sub_subfield' $file | tr '\n' ';' | sed 's/;$//g'; echo ""; done | grep -vE '^[;\s]*$' >> fields.csv

# Load the ggplot2 library
library(ggplot2)

# Read the CSV file into a data frame
data <- read.csv("fields.csv", sep = ";")

# Create a bar chart for the "field" category
ggplot(data, aes(x = field)) +
  geom_bar(fill = "blue") +
  labs(title = "Distribution of publications in TextoLivre by Field", x = "Field", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(file="histogram.png")

unique_fields <- unique(data$field)
histograms <- list()
for (field in unique_fields) {
  subset_data <- data[data$field == field, ]
  p <- ggplot(subset_data, aes(x = subfield)) +
      geom_bar() +
      labs(title = paste("Histogram of Subfields for ", field), x = "Subfield", y = "Count") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  histograms[[field]] <- p
}

for (field in unique_fields) {
    ggsave(filename = paste(gsub(" ", "_", field), "histogram.png", sep = ""), plot = histograms[[field]], device = "png")
}

