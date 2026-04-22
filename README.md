# 📊 User Retention Analysis: Cohort Study (SQL & Google Sheets)

Аналіз життєвого циклу користувачів та показників утримання (Retention Rate) на основі когортного аналізу для порівняння ефективності промо-акцій та органічного залучення.

## Про проєкт
Головна мета цього проєкту — зрозуміти, як довго користувачі залишаються активними в системі після реєстрації та як на їхню лояльність впливає спосіб залучення (промо-код чи органічний пошук). Аналіз допомагає бізнесу виявити "точки відтоку" та оцінити якість трафіку.

Найскладнішою частиною була попередня обробка даних (Data Cleaning). Вхідні дані містили дати у різних текстових форматах з різними розділювачами. За допомогою складних SQL-запитів мені вдалося уніфікувати тисячі записів, що дозволило точно розрахувати "стаж" кожного користувача (month offset).

## Терміни та визначення
* **Когорта (Cohort)** — група користувачів, об'єднана спільним місяцем реєстрації.
* **Retention Rate (RR)** — відсоток користувачів з когорти, які повернулися в компанію через певний проміжок часу.
* **Month Offset** — кількість місяців, що минули з моменту реєстрації (0 — місяць реєстрації, 1 — наступний місяць тощо).
* **Promo vs Organic** — порівняння користувачів, що прийшли за акцією, та тих, хто знайшов сервіс самостійно.

## Основні етапи
1.  **Data Cleaning & Transformation (SQL):** Використав PostgreSQL для обробки сирих даних. За допомогою регулярних виразів та конструкцій `CASE` трансформував текстові дати (різні формати: DD.MM.YYYY, DD/MM/YY тощо) у тип `timestamp`.

2.  **Cohort Preparation:** Розрахував місяць залучення та різницю в місяцях між реєстрацією та кожною подією (login, purchase тощо). Відфільтрував тестові події та некоректні записи.

3.  **Aggregation:** Сформував фінальну таблицю з кількістю унікальних користувачів для кожної когорти, розділену за типом залучення.

4.  **Visualization (Google Sheets):** Побудував інтерактивну "трикутну" когортну таблицю.

5.  **Analytics & Insights:** Використав умовне форматування (Heatmap) для візуалізації Retention Rate та додав зрізи (Slicers) для миттєвої фільтрації між Promo та Organic групами.

## Функції та методи
* **SQL:** CTE (Common Table Expressions), `REGEXP_REPLACE`, `SPLIT_PART`, `TO_DATE`, `COALESCE`, `JOIN`, `EXTRACT` (для розрахунку зсуву місяців).
* **Google Sheets:** Pivot Tables (Зведені таблиці), Conditional Formatting (градієнт), Slicers, розрахункові поля для % Retention.

## Висновки
Аналіз продемонстрував різницю в поведінці користувачів: зазвичай "промо-користувачі" показують вищий приток на старті, але можуть мати швидший відтік (churn), тоді як "органічні" користувачі демонструють стабільніше утримання на довгій дистанції. (Детальний висновок додано у звіті Google Sheets).

---

# 📊 User Retention Analysis: Cohort Study (SQL & Google Sheets)

Time-series analysis of user loyalty and Retention Rate using cohort analysis to compare the effectiveness of promotional campaigns versus organic user acquisition.

## Project Overview
The primary goal of this project was to assess how long users remain active after their initial sign-up and how their loyalty is affected by the acquisition source (Promo vs. Organic). This analysis provides a foundation for identifying "churn points" and evaluating traffic quality.

The most challenging part of the project was Data Cleaning. The raw datasets contained dates in inconsistent text formats with various delimiters. Using advanced SQL techniques, I standardized thousands of records, which allowed for the accurate calculation of each user's "tenure" (month offset) within the company.

## Terms and Definitions
* **Cohort** — a group of users who signed up during the same month.
* **Retention Rate (RR)** — the percentage of users from a cohort who return to the service after a specific period.
* **Month Offset** — the number of months since registration (0 = registration month, 1 = first month after, etc.).
* **Promo vs Organic** — a comparison between users acquired via promotions and those acquired through organic channels.

## Main Stages
1.  **Data Cleaning & Transformation (SQL):** Utilized PostgreSQL to process raw data. Employed Regular Expressions and `CASE` statements to transform inconsistent text dates (formats like DD.MM.YYYY, DD/MM/YY, etc.) into unified `timestamp` values.

2.  **Cohort Preparation:** Calculated the acquisition month and the month difference (offset) between registration and subsequent events. Filtered out test events and NULL values.

3.  **Aggregation:** Created a final aggregated table showing unique user counts per cohort, segmented by promo status.

4.  **Visualization (Google Sheets):** Developed an interactive "triangular" cohort table.

5.  **Analytics & Insights:** Applied Conditional Formatting (Heatmaps) to visualize Retention Rate trends and implemented Slicers for dynamic filtering between Promo and Organic segments.

## Functions and Techniques
* **SQL:** CTE (Common Table Expressions), `REGEXP_REPLACE`, `SPLIT_PART`, `TO_DATE`, `LEFT JOIN`, Date Arithmetics (`EXTRACT` for month difference).
* **Google Sheets:** Pivot Tables, Conditional Formatting (color scales), Slicers, and custom formulas for % Retention calculation.

## Insights
The analysis revealed distinct behavioral patterns: while "promo users" often show a higher initial volume, they may exhibit a steeper churn rate compared to "organic users," who tend to demonstrate more stable long-term retention. (Detailed insights are available in the Google Sheets report).
