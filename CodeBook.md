---
title: "CodeBook.md"
author: "Diego Brusetti"
date: "Sunday, February 22, 2015"
output: html_document
---

## TidyDataset
The **TidyDataset** is a table that summarize the data collected by "*UCI HAR Dataset*" (downloadable at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), grouping them by "Activity Name" and "Subject ID".
For each observation, I selected all the average and stddev measurements, then I summarized each measurements with its average per activity and per subject.

## Column definitions

- **Activity_Name**: the name of the body behavior
- **Subject_ID**: the identification number of the person who carried out the experiment
- **std()**: names containing \*std\* refers to the standard deviation of that variable -- When specified, **X**, **Y**, **Z** are the names of the movement's spatial dimension
- **mean()**: names containing \*mean()\* refers to the arithmetic mean of that variable -- When specified, **X**, **Y**, **Z** are the names of the movement's spatial dimension
- **meanFreq()**: names containing \*meanFreq()\* refers to the arithmetic mean of the frequency of that variable -- When specified, **X**, **Y**, **Z** are the names of the movement's spatial dimension

## Details
The **TidyDataset** is a collection of 35 observations of 81 variables, being the firts two just identification names.
The **Activity_Name** is a factor of 6 levels, identifying different body behaviors: *LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS*. Instead, **Subject_ID** is a number between 1 an 30.
All the values are normalized (no units).