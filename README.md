

# Walmart Sales Analysis & Customer Insights Dashboard

This project analyzes retail sales data from Walmart to uncover customer behavior, revenue trends, and performance patterns across products, branches, and demographics. The final output is an interactive Tableau dashboard designed to aid data-driven decision making.



## Project Objective

To deliver actionable insights by analyzing customer transactions, sales trends, and operational performance across different dimensions such as gender, product lines, and time of day. The project simulates a real-world business case using SQL for data wrangling and Tableau for visualization.

---

## 📂 Project Structure

```
📁 data/
│   ├── WalmartSalesData_Raw.csv              # Original raw data
│   └── processed_walmart_sales_data.csv      # Cleaned and transformed data via SQL

📁 analysis/
│   └── walmart_sql_analysis.sql              # Full SQL script for data prep and analysis

📁 dashboard/
│   └── Walmart_Sales_Insights.twbx           # Tableau Workbook with all charts and KPIs
```

---

## 🛠 Tools Used

* **PostgreSQL** – Data cleaning, transformation, feature creation (month name, time of day, etc.)
* **Tableau** – Interactive dashboard, KPIs, and visual storytelling
* **pgAdmin** – SQL execution and CSV export
* **ChatGPT** – Acted as a virtual data consultant to review SQL logic, guide dashboard planning, and ensure clarity, accuracy, and business alignment across all steps

---

##  Key Questions Answered

* Which product lines generate the most revenue?
* How do gender and customer type affect sales?
* What times of the day and days of the week see the highest activity?
* Which branches and cities are top performers?
* Which customer segments contribute most to revenue?
* What are the patterns in VAT (tax) and ratings?

---

## 📊 Dashboard Highlights

The Tableau dashboard includes:

* **KPI Cards** – Total Revenue, Average Rating, Total Units Sold
* **Donut Chart** – Payment method distribution
* **Bar Charts** – Revenue by customer type, VAT by customer type
* **Stacked Bar Chart** – Product line preference by gender
* **Heatmap** – Average ratings by branch and time of day
* **Table** – Top product lines by gender
* **Trend Line** – Monthly average hourly revenue by gender

Each chart is filterable by branch, gender, and customer type to enable dynamic exploration.

---

##  Business Insights

* **Evening hours** drive the highest revenue across all branches.
* **Electronic Accessories** and **Food & Beverages** dominate product line sales.
* **Branch A** has the highest overall performance in terms of both revenue and quantity sold.
* **Credit Card** is the most used payment method, followed by Cash.
* Female customers slightly dominate in **Fashion Accessories** and **Health & Beauty** purchases.

---

##  How It Works

1. **Data Cleaning**: Raw CSV is loaded into PostgreSQL.
2. **SQL Analysis**: Data is transformed using SQL (add columns like `month_name`, `time_of_day`, `day_name`, etc.)
3. **Export to CSV**: Cleaned dataset is exported.
4. **Tableau**: Visualizations and dashboard are built using the exported file.
5. **GitHub Upload**: All project files are organized and uploaded for public access and portfolio visibility.

---

##  Usage

* Open `Walmart_Sales_Insights.twbx` in Tableau Desktop or Tableau Public.
* Interact with filters to slice data by branch, customer type, or gender.
* View insights across multiple dimensions including time, product, and payment methods.


