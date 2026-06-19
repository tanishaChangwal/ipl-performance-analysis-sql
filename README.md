# IPL Data Analysis Using SQL

# Project Overview
* This project analyzes Indian Premier League (IPL) match and ball-by-ball data using MySQL.
* The objective was to design a relational database, clean and transform raw datasets, and perform exploratory and business-focused analysis using SQL queries.
* The project covers team performance, player statistics, venue analysis, match outcomes, and scoring trends across IPL seasons.

# Dataset
The project uses two datasets:

## Matches Table
Contains match-level information including:
* Season
* Venue
* Teams
* Toss Results
* Match Winners
* Target Runs
* Match Type

## Deliveries Table
Contains ball-by-ball information including:
* Batter
* Bowler
* Runs Scored
* Extras
* Wickets
* Dismissal Types

# Database Design
Two tables were created:
* matches
* deliveries
The tables were connected using a Primary Key and Foreign Key relationship.

# Data Cleaning
Data preprocessing included:
* Handling NULL values
* Replacing missing cities and winners
* Cleaning season values
* Standardizing categorical values
* Checking duplicates
* Validating numerical fields
* Creating indexes for query optimization

# SQL Concepts Used
* DDL (CREATE DATABASE, CREATE TABLE)
* Data Import using LOAD DATA INFILE
* Data Cleaning
* Joins
* Aggregate Functions
* GROUP BY
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* Views
* Indexing

# Business Questions Answered
1. Which team won the most IPL titles?
2. Which teams have the highest win percentage?
3. Does winning the toss increase chances of winning?
4. Who are the top run scorers?
5. Who are the leading wicket takers?
6. Which venues host the most matches?
7. What are the highest scoring matches?
8. Which teams perform best during the powerplay?

# Key Insights
* Identified the most successful IPL teams based on overall wins and titles.
* Analyzed batting and bowling performance across seasons.
* Evaluated the impact of toss decisions on match outcomes.
* Discovered scoring trends during powerplay, middle overs, and death overs.
* Compared venue performance and batting-friendly stadiums.

# Skills Demonstrated
* SQL
* MySQL
* Database Design
* Data Cleaning
* Exploratory Data Analysis
* Query Optimization
* Data Modeling
* Business Analytics
