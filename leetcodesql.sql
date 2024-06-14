-- 1757. Recyclable and Low Fat Products
-- https://leetcode.com/problems/recyclable-and-low-fat-products/description/?envType=study-plan-v2&envId=top-sql-50
/* Write your T-SQL query statement below */
SELECT product_id  
FROM Products 
WHERE low_fats LIKE 'Y' 
AND recyclable LIKE 'Y';

-- 584. Find Customer Referee
-- https://leetcode.com/problems/find-customer-referee/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT name 
FROM Customer 
WHERE ISNULL(referee_id, 0) <> 2;

-- 595. Big Countries
-- https://leetcode.com/problems/big-countries/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT name, population, area 
FROM World 
WHERE area >= 3000000 
OR population >= 25000000;

-- 1148. Article Views I
-- https://leetcode.com/problems/article-views-i/?envType=study-plan-v2&envId=top-sql-50
/* Write your T-SQL query statement below */
SELECT DISTINCT author_id AS id 
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC;

-- 1683. Invalid Tweets
-- https://leetcode.com/problems/invalid-tweets/description/?envType=study-plan-v2&envId=top-sql-50
/* Write your T-SQL query statement below */
SELECT tweet_id 
FROM Tweets 
WHERE LEN(content) > 15;

-- 1378. Replace Employee ID With The Unique Identifier
-- https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/?envType=study-plan-v2&envId=top-sql-50
/* Write your T-SQL query statement below */
WITH cte AS (
    SELECT name, unique_id
    FROM Employees
    LEFT JOIN EmployeeUNI ON EmployeeUNI.id = Employees.id
)
SELECT unique_id, name 
FROM cte;

-- 1068. Product Sales Analysis I
-- https://leetcode.com/problems/product-sales-analysis-i/?envType=problem-list-v2&envId=rdrp7yhj
/* Write your T-SQL query statement below */
SELECT product_name, year, price 
FROM Sales 
JOIN Product ON Product.product_id = Sales.product_id;

-- 1581. Customer Who Visited but Did Not Make Any Transactions
-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/?envType=study-plan-v2&envId=top-sql-50
/* Write your T-SQL query statement below */
SELECT customer_id, COUNT(customer_id) AS count_no_trans
FROM Visits
WHERE visit_id NOT IN (SELECT visit_id FROM Transactions)
GROUP BY customer_id;

-- 197. Rising Temperature
-- https://leetcode.com/problems/rising-temperature/description/?envType=study-plan-v2&envId=top-sql-50
SELECT w1.ID AS Id
FROM Weather AS w1, Weather AS w2
WHERE w1.temperature > w2.temperature
AND w1.recordDate = DATEADD(DAY, 1, w2.recordDate);

-- 1661. Average Time of Process per Machine
-- https://leetcode.com/problems/average-time-of-process-per-machine/description/?envType=study-plan-v2&envId=top-sql-50
WITH unpivoted_table AS (
    SELECT machine_id, process_id, ISNULL([start], 0) AS StartTime, ISNULL([end], 0) AS EndTime
    FROM (
        SELECT * 
        FROM Activity
    ) AS SourceTable
    PIVOT (
        SUM(timestamp) FOR activity_type IN ([start], [end])
    ) AS PivotTable
) 
SELECT machine_id, ROUND(SUM(EndTime - StartTime) / COUNT(process_id), 3) AS processing_time
FROM unpivoted_table
GROUP BY machine_id;

-- 577. Employee Bonus
-- https://leetcode.com/problems/employee-bonus/?envType=problem-list-v2&envId=rdrp7yhj
SELECT name, bonus
FROM Employee
LEFT JOIN Bonus ON Bonus.empId = Employee.empID
WHERE ISNULL(bonus, 0) < 1000;

-- 1280. Students and Examinations
-- https://leetcode.com/problems/students-and-examinations/?envType=study-plan-v2&envId=top-sql-50
SELECT S.student_id, S.student_name, S.subject_name, ISNULL(E.attended_exams, 0) AS attended_exams
FROM students_subject S
LEFT JOIN Exam_Count E ON E.student_id = S.student_id AND E.subject_name = S.subject_name
ORDER BY student_id, subject_name;

WITH students_subject AS (
    SELECT * 
    FROM Students 
    CROSS JOIN Subjects
), 
Exam_Count AS (
    SELECT student_id, subject_name, COUNT(subject_name) AS attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
);

-- 570. Managers with at Least 5 Direct Reports
-- https://leetcode.com/problems/managers-with-at-least-5-direct-reports/?envType=problem-list-v2&envId=rdrp7yhj
SELECT name  
FROM Employee  
WHERE id IN ( 
    SELECT managerId  
    FROM Employee  
    GROUP BY managerId  
    HAVING COUNT(*) >= 5
);

-- 1934. Confirmation Rate
-- https://leetcode.com/problems/confirmation-rate/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH pivoted_data AS (
    SELECT user_id, 
        SUM(ISNULL([timeout], 0)) AS Timeout, 
        SUM(ISNULL([confirmed], 0)) AS Confirmed,
        SUM(ISNULL([timeout], 0)) + SUM(ISNULL([confirmed], 0)) AS total
    FROM (
        SELECT * 
        FROM Confirmations
    ) AS originalTable
    PIVOT (
        COUNT(action) FOR action IN ([timeout], [confirmed])
    ) AS PivotTable
    GROUP BY user_id
) 
SELECT O.user_id, ISNULL(ROUND(((confirmed + 0.00) / total), 2), 0.00) AS confirmation_rate 
FROM Signups O
LEFT JOIN pivoted_data ON pivoted_data.user_id = O.user_id;

-- 620. Not Boring Movies
-- https://leetcode.com/problems/not-boring-movies/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT * 
FROM Cinema
WHERE (ID + 0.00) % 2 = 1 
AND description NOT LIKE 'boring'
ORDER BY rating DESC;

-- 1251. Average Selling Price
-- https://leetcode.com/problems/average-selling-price/?envType=study-plan-v2&envId=top-sql-50
WITH pricing_total AS (
    SELECT prices.product_id, 
        UnitsSold.units, 
        prices.price, 
        ISNULL(UnitsSold.units * prices.price, 0) AS total 
    FROM prices
    LEFT JOIN UnitsSold ON UnitsSold.product_id = prices.product_id 
        AND (purchase_date >= start_date AND purchase_date <= end_date)
) 
SELECT product_id, ISNULL(ROUND(SUM(total + 0.00) / SUM(units), 2), 0) AS average_price
FROM pricing_total
GROUP BY product_id;

-- 1075. Project Employees I
-- https://leetcode.com/problems/project-employees-i/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT project_id, ROUND(AVG(experience_years + 0.00), 2) AS average_years 
FROM Project 
INNER JOIN Employee ON Employee.employee_id = Project.employee_id
GROUP BY project_id;

-- 1633. Percentage of Users Attended a Contest
-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/?envType=study-plan-v2&envId=top-sql-50
WITH output_table AS (
    SELECT contest_id, 
        (COUNT(user_id) + 0.00) / (SELECT COUNT(user_id) FROM Users) * 100 AS percentage
    FROM Register
    GROUP BY contest_id
) 
SELECT contest_id, ROUND(percentage, 2) AS percentage  
FROM output_table
ORDER BY percentage DESC, contest_id ASC;

-- 1211. Queries Quality and Percentage
-- https://leetcode.com/problems/queries-quality-and-percentage/description/?envType=study-plan-v2&envId=top-sql-50
SELECT query_name, 
    ROUND(AVG(rating * 1.0 / position), 2) AS quality, 
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS poor_query_percentage
FROM queries
WHERE query_name IS NOT NULL
GROUP BY query_name;

-- 1193. Monthly Transactions I
-- https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    FORMAT(trans_date, 'yyyy-MM') AS Month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state LIKE 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state LIKE 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    FORMAT(trans_date, 'yyyy-MM'), country;

-- 1174. Immediate Food Delivery II
-- https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50
WITH customerRanking AS (
    SELECT *,
           CASE WHEN order_date = customer_pref_delivery_date THEN 'immediate' ELSE 'scheduled' END AS status,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS OrderRank
    FROM 
        Delivery
) 
SELECT
    ROUND(SUM(CASE WHEN status LIKE 'immediate' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS immediate_percentage
FROM 
    customerRanking 
WHERE 
    OrderRank = 1;

-- 550. Game Play Analysis IV
-- https://leetcode.com/problems/game-play-analysis-iv/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH v1 AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login
    FROM 
        activity
    GROUP BY 
        player_id
)
SELECT 
    ROUND(CAST(SUM(CASE WHEN DATEDIFF(day, first_login, event_date) = 1 THEN 1 ELSE 0 END) AS FLOAT) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM 
    v1
JOIN 
    activity a ON a.player_id = v1.player_id;

-- 2356. Number of Unique Subjects Taught by Each Teacher
-- https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    teacher_id, 
    COUNT(DISTINCT subject_id) AS cnt
FROM 
    Teacher 
GROUP BY 
    teacher_id;

-- 1141. User Activity for the Past 30 Days I
-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    activity_date AS day, 
    COUNT(DISTINCT user_id) AS active_users
FROM 
    Activity 
WHERE 
    activity_date BETWEEN DATEADD(DAY, -29, '2019-07-27') AND '2019-07-27'
GROUP BY 
    activity_date;

-- 1070. Product Sales Analysis III
-- https://leetcode.com/problems/product-sales-analysis-iii/?envType=problem-list-v2&envId=rdrp7yhj
WITH rankingTable AS (
    SELECT 
        product_id, 
        year, 
        quantity, 
        price,
        DENSE_RANK() OVER (PARTITION BY product_id ORDER BY year ASC) AS yearRanking
    FROM 
        sales
)
SELECT 
    product_id, 
    year AS first_year, 
    quantity, 
    price
FROM 
    rankingTable 
WHERE 
    yearRanking = 1;

-- 596. Classes More Than 5 Students
-- https://leetcode.com/problems/classes-more-than-5-students/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT 
        class, 
        COUNT(student) AS ct 
    FROM 
        Courses
    GROUP BY 
        class 
) 
SELECT 
    class 
FROM 
    cte 
WHERE 
    ct >= 5;

-- 1729. Find Followers Count
-- https://leetcode.com/problems/find-followers-count/description/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    user_id, 
    COUNT(follower_id) AS followers_count
FROM 
    Followers
GROUP BY 
    user_id
ORDER BY 
    user_id ASC;

-- 619. Biggest Single Number
-- https://leetcode.com/problems/biggest-single-number/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT 
        num, 
        COUNT(num) AS countNum 
    FROM 
        MyNumbers
    GROUP BY 
        num 
)
SELECT 
    ISNULL(MAX(num), NULL) AS num 
FROM 
    cte 
WHERE 
    countNum = 1;

-- 1045. Customers Who Bought All Products
-- https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT 
    DISTINCT customer_id 
FROM 
    Customer 
GROUP BY 
    customer_id
HAVING 
    COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM product);

-- 1731. The Number of Employees Which Report to Each Employee
-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/?envType=study-plan-v2&envId=top-sql-50
SELECT
    E.employee_id, 
    E.name,
    COUNT(R.reports_to) AS reports_count,
    ROUND(AVG(R.age * 1.0), 0) AS average_age
FROM 
    Employees E
JOIN 
    Employees R ON R.reports_to = E.employee_id
GROUP BY 
    E.employee_id, E.name
ORDER BY 
    E.employee_id ASC;

-- 1789. Primary Department for Each Employee
-- https://leetcode.com/problems/primary-department-for-each-employee/description/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    employee_id, 
    department_id 
FROM 
    Employee
WHERE 
    primary_flag = 'Y'
UNION
SELECT 
    employee_id, 
    MAX(department_id) 
FROM 
    Employee 
GROUP BY 
    employee_id
HAVING 
    COUNT(department_id) = 1;

-- 610. Triangle Judgement
-- https://leetcode.com/problems/triangle-judgement/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT 
    *,
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes' 
        ELSE 'No' 
    END AS triangle
FROM 
    Triangle;

-- 180. Consecutive Numbers
-- https://leetcode.com/problems/consecutive-numbers/?envType=study-plan-v2&envId=top-sql-50
WITH ReformTable AS (
    SELECT 
        *, 
        LAG(num) OVER (ORDER BY ID ASC) AS LagValue,
        LEAD(num) OVER (ORDER BY ID ASC) AS LeadValue
    FROM 
        Logs
) 
SELECT 
    DISTINCT num AS ConsecutiveNums 
FROM 
    ReformTable
WHERE 
    LagValue = Num AND LeadValue = num;

-- 1164. Product Price at a Given Date
-- https://leetcode.com/problems/product-price-at-a-given-date/description/?envType=study-plan-v2&envId=top-sql-50
SELECT
    product_id, 
    FIRST_VALUE(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) AS price
FROM 
    Products
WHERE 
    change_date <= '2019-08-16'
UNION 
SELECT
    product_id,
    10 AS price
FROM 
    Products
GROUP BY 
    product_id
HAVING 
    MIN(change_date) > '2019-08-16';

-- 1204. Last Person to Fit in the Bus
-- https://leetcode.com/problems/last-person-to-fit-in-the-bus/description/?envType=study-plan-v2&envId=top-sql-50
WITH order_ranking AS (
    SELECT *,
        SUM(weight) OVER (ORDER BY turn ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
    FROM 
        Queue
)
SELECT 
    TOP 1 person_name 
FROM 
    order_ranking 
WHERE 
    RunningTotal <= 1000 
ORDER BY 
    turn DESC;

-- 1907. Count Salary Categories
-- https://leetcode.com/problems/count-salary-categories/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT *, 
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            ELSE 'High Salary' 
        END AS category
    FROM 
        Accounts 
)
SELECT 
    X.Category AS category,
    ISNULL(COUNT(cte.category), 0) AS accounts_count
FROM 
    (VALUES ('Low Salary'), ('Average Salary'), ('High Salary')) AS X(Category)
LEFT JOIN 
    cte ON X.Category = cte.category
GROUP BY 
    X.Category;

-- 1978. Employees Whose Manager Left the Company
-- https://leetcode.com/problems/employees-whose-manager-left-the-company/description/?envType=problem-list-v2&envId=top-sql-50
SELECT 
    employee_id 
FROM 
    Employees 
WHERE 
    salary < 30000 
    AND manager_id NOT IN (SELECT DISTINCT employee_id FROM Employees)
ORDER BY 
    employee_id;

-- 626. Exchange Seats
-- https://leetcode.com/problems/exchange-seats/description/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT 
        id, 
        student,
        LAG(student) OVER (ORDER BY ID) AS lagValue,
        LEAD(student, 1, student) OVER (ORDER BY ID) AS leadValue
    FROM 
        Seat
)
SELECT 
    id,
    CASE 
        WHEN id % 2 = 1 THEN leadValue 
        ELSE lagValue 
    END AS student
FROM 
    cte;

-- 1341. Movie Rating
-- https://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50
WITH TopUser AS (
    SELECT TOP 1 
        u.name AS name1, 
        COUNT(*) AS rating_count
    FROM 
        MovieRating mr
    INNER JOIN 
        users u ON u.user_id = mr.user_id
    GROUP BY 
        u.name
    ORDER BY 
        rating_count DESC, 
        name1 ASC
),
MovieRatings AS (
    SELECT TOP 1
        m.title, 
        AVG(CAST(mr.rating AS DECIMAL(10, 2))) AS average_rating
    FROM 
        MovieRating mr 
    INNER JOIN 
        movies m ON mr.movie_id = m.movie_id
    WHERE 
        mr.created_at >= '2020-02-01' AND mr.created_at <= '2020-02-29'
    GROUP BY 
        m.title
    ORDER BY 
        average_rating DESC, 
        m.title ASC
)
SELECT 
    name1 AS results
FROM 
    TopUser
UNION ALL
SELECT 
    title AS results
FROM 
    MovieRatings;

-- 1321. Restaurant Growth
-- https://leetcode.com/problems/restaurant-growth/description/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT 
        visited_on, 
        SUM(amount) AS amount
    FROM 
        customer 
    GROUP BY 
        visited_on
)
SELECT 
    visited_on, 
    SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount, 
    ROUND(AVG(amount * 1.0) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount 
FROM 
    cte 
ORDER BY 
    visited_on
OFFSET 6 ROWS;

-- 602. Friend Requests II: Who Has the Most Friends
-- https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT 
        requester_id 
    FROM 
        RequestAccepted
    UNION ALL
    SELECT 
        accepter_id 
    FROM 
        RequestAccepted
)
SELECT 
    TOP 1 requester_id AS id,
    COUNT(*) AS num
FROM 
    cte 
GROUP BY 
    requester_id
ORDER BY 
    COUNT(*) DESC;

-- 585. Investments in 2016
-- https://leetcode.com/problems/investments-in-2016/description/?envType=problem-list-v2&envId=top-sql-50
WITH cte AS (
    SELECT 
        pid, 
        TIV_2015, 
        TIV_2016, 
        COUNT(CONCAT(lat, lon)) OVER (PARTITION BY CONCAT(lat, lon)) AS cityCount, 
        COUNT(TIV_2015) OVER (PARTITION BY TIV_2015) AS InvCount
    FROM 
        insurance
)
SELECT 
    ROUND(SUM(TIV_2016 * 1.0), 2) AS TIV_2016 
FROM 
    cte 
WHERE 
    cityCount = 1 AND InvCount != 1;

-- 185. Department Top Three Salaries
-- https://leetcode.com/problems/department-top-three-salaries/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT  
        D.name AS Department, 
        E.name AS Employee, 
        E.Salary,
        DENSE_RANK() OVER (PARTITION BY D.name ORDER BY E.Salary DESC) AS Ranking
    FROM 
        Employee E
    LEFT JOIN 
        Department D ON D.id = E.departmentid
) 
SELECT 
    Department, 
    Employee, 
    Salary 
FROM 
    cte 
WHERE 
    Ranking <= 3;

-- 1667. Fix Names in a Table
-- https://leetcode.com/problems/fix-names-in-a-table/description/?envType=study-plan-v2&envId=top-sql-50
SELECT 
    user_id,
    CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2, LEN(name) - 1))) AS name
FROM Users
ORDER BY user_id;

-- 1527. Patients With a Condition
-- https://leetcode.com/problems/patients-with-a-condition/description/?envType=study-plan-v2&envId=top-sql-50
SELECT * FROM Patients 
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%'

-- 1965. Employees With Missing Information
--https://leetcode.com/problems/employees-with-missing-information/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH CTE AS (
    SELECT 
        Employees.employee_id AS EID, 
        Employees.name, 
        Salaries.employee_id AS SID,
        Salaries.salary
    FROM Employees
    FULL OUTER JOIN Salaries
        ON Salaries.employee_id = Employees.employee_id
),
CombineT AS (
    SELECT SID AS employee_id FROM CTE 
    WHERE name IS NULL 
    UNION ALL 
    SELECT EID AS employee_id FROM CTE 
    WHERE salary IS NULL
)
SELECT * FROM CombineT
ORDER BY employee_id

-- 176. Second Highest Salary
-- https://leetcode.com/problems/second-highest-salary/?envType=problem-list-v2&envId=rdrp7yhj
WITH tblSalaryRank AS (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS RankID
    FROM Employee
)
SELECT (
    SELECT MAX(salary) 
    FROM tblSalaryRank
    WHERE RankID = 2
) AS SecondHighestSalary

-- 1484. Group Sold Products By The Date
-- https://leetcode.com/problems/group-sold-products-by-the-date/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY sell_date, product ORDER BY sell_date, product) AS ranking
    FROM Activities
)
SELECT 
    sell_date, 
    COUNT(product) AS num_sold, 
    STRING_AGG(product, ',') AS products
FROM cte 
WHERE ranking = 1
GROUP BY sell_date

-- 1327. List the Products Ordered in a Period
-- https://leetcode.com/problems/list-the-products-ordered-in-a-period/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT 
        O.order_date,
        P.product_name,
        O.unit
    FROM Orders O
    LEFT JOIN Products P ON O.product_id = P.product_id
    WHERE MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2020
)
SELECT product_name, SUM(unit) AS unit 
FROM cte
GROUP BY product_name
HAVING SUM(unit) >= 100 

-- 1517. Find Users With Valid E-Mails
-- https://leetcode.com/problems/find-users-with-valid-e-mails/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT user_id, name, mail 
FROM Users
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode[.]com'

-- 1407. Top Travellers
-- https://leetcode.com/problems/top-travellers/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT 
        name, 
        ISNULL(SUM(distance), 0) AS travelled_distance
    FROM Users
    LEFT JOIN Rides ON Rides.User_id = Users.id
    GROUP BY name, Users.id
)
SELECT name, travelled_distance 
FROM cte 
ORDER BY travelled_distance DESC, name ASC

-- 586. Customer Placing the Largest Number of Orders
-- https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH cte AS (
    SELECT customer_number, COUNT(*) AS ct
    FROM Orders 
    GROUP BY customer_number
) 
SELECT TOP 1 customer_number 
FROM cte
ORDER BY ct DESC

-- 596. Classes More Than 5 Students
-- https://leetcode.com/problems/classes-more-than-5-students/description/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT class, COUNT(student) AS ct 
    FROM Courses
    GROUP BY class 
) 
SELECT class 
FROM cte 
WHERE ct >= 5

-- 601. Human Traffic of Stadium
-- https://leetcode.com/problems/human-traffic-of-stadium/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH t AS (
    SELECT *, id - ROW_NUMBER() OVER (ORDER BY id ASC) AS rnk
    FROM Stadium
    WHERE people >= 100
)
SELECT id, visit_date, people
FROM t
WHERE rnk IN (SELECT rnk FROM t GROUP BY rnk HAVING COUNT(*) >= 3)

-- 608. Tree Node
-- https://leetcode.com/problems/tree-node/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT id,
    CASE 
        WHEN p_id IS NULL OR (p_id IS NULL AND id IN (SELECT p_id FROM Tree)) THEN 'Root' 
        WHEN p_id IS NOT NULL AND id IN (SELECT p_id FROM Tree) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree

-- 619. Biggest Single Number
-- https://leetcode.com/problems/biggest-single-number/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT num, COUNT(num) AS countNum 
    FROM MyNumbers
    GROUP BY num 
)
SELECT ISNULL(MAX(num), NULL) AS num 
FROM cte 
WHERE countNum = 1

-- 1045. Customers Who Bought All Products
-- https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=study-plan-v2&envId=top-sql-50
SELECT DISTINCT customer_id 
FROM Customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product)

-- 1050. Actors and Directors Who Cooperated At Least Three Times
-- https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT actor_id, director_id 
FROM ActorDirector
GROUP BY actor_id, director_id 
HAVING COUNT(*) >= 3

-- 627. Swap Salary
-- https://leetcode.com/problems/swap-salary/description/?envType=problem-list-v2&envId=rdrp7yhj
UPDATE Salary 
SET sex = CASE 
            WHEN sex = 'm' THEN 'f' 
            WHEN sex = 'f' THEN 'm' 
          END

-- 1084. Sales Analysis III
-- https://leetcode.com/problems/sales-analysis-iii/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT p.product_id, p.product_name
FROM Product p
LEFT JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) > '2018-12-31' AND MAX(s.sale_date) < '2019-04-01'

-- 1741. Find Total Time Spent by Each Employee
-- https://leetcode.com/problems/find-total-time-spent-by-each-employee/
WITH cte AS (
    SELECT player_id, event_date, 
        DENSE_RANK() OVER (PARTITION BY Player_ID ORDER BY event_date ASC) AS ranking 
    FROM Activity
)
SELECT player_id, event_date AS first_login
FROM cte 
WHERE ranking = 1

-- 177. Nth Highest Salary
-- https://leetcode.com/problems/nth-highest-salary/description/?envType=problem-list-v2&envId=rdrp7yhj
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
   RETURN (
       SELECT TOP 1 salary
       FROM (
           SELECT salary, 
           DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking 
           FROM Employee
       ) subq
       WHERE subq.ranking = @N
   );
END

-- 175. Combine Two Tables
-- https://leetcode.com/problems/combine-two-tables/?envType=problem-list-v2&envId=rdrp7yhj
SELECT firstName, lastName, ISNULL(city, NULL) AS city, ISNULL(state, NULL) AS state 
FROM Person 
LEFT JOIN Address ON Address.personId = Person.personID

-- 178. Rank Scores
-- https://leetcode.com/problems/rank-scores/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT score, 
    DENSE_RANK() OVER (ORDER BY score DESC) AS rank
FROM Scores


-- 262. Trips and Users
-- https://leetcode.com/problems/trips-and-users/description/?envType=problem-list-v2&envId=rdrp7yhj
WITH not_banned AS (
    SELECT users_id 
    FROM Users
    WHERE banned = 'No'
)
SELECT 
    request_at AS day, 
    ROUND(SUM(CASE WHEN status LIKE 'Cancelled%' THEN 1.0 ELSE 0 END) / COUNT(*), 2) AS 'Cancellation Rate'  
FROM Trips
WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
    AND client_id IN (SELECT users_id FROM not_banned)
    AND driver_id IN (SELECT users_id FROM not_banned)
GROUP BY request_at

-- 1179. Reformat Department Table
-- https://leetcode.com/problems/reformat-department-table/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT 
    id,
    ISNULL([Jan], 0) AS Jan_Revenue,
    ISNULL([Feb], 0) AS Feb_Revenue,
    ISNULL([Mar], 0) AS Mar_Revenue,
    ISNULL([Apr], 0) AS Apr_Revenue,
    ISNULL([May], 0) AS May_Revenue,
    ISNULL([Jun], 0) AS Jun_Revenue,
    ISNULL([Jul], 0) AS Jul_Revenue,
    ISNULL([Aug], 0) AS Aug_Revenue,
    ISNULL([Sep], 0) AS Sep_Revenue,
    ISNULL([Oct], 0) AS Oct_Revenue,
    ISNULL([Nov], 0) AS Nov_Revenue,
    ISNULL([Dec], 0) AS Dec_Revenue
FROM (
    SELECT * FROM Department
) AS OriginalTable
PIVOT (
    MAX(revenue)
    FOR MONTH IN ([Jan], [Feb], [Mar], [Apr], [May], [Jun], [Jul], [Aug], [Sep], [Oct], [Nov], [Dec])
) AS PivotTable;

-- Alternative Query
SELECT 
    id,
    Jan AS Jan_Revenue,
    Feb AS Feb_Revenue,
    Mar AS Mar_Revenue,
    Apr AS Apr_Revenue,
    May AS May_Revenue,
    Jun AS Jun_Revenue,
    Jul AS Jul_Revenue,
    Aug AS Aug_Revenue,
    Sep AS Sep_Revenue,
    Oct AS Oct_Revenue,
    Nov AS Nov_Revenue,
    Dec AS Dec_Revenue
FROM (
    SELECT * FROM Department
) AS OriginalTable
PIVOT (
    MAX(revenue)
    FOR MONTH IN (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
) AS PivotTable;

-- 1795. Rearrange Products Table
-- https://leetcode.com/problems/rearrange-products-table/description/?envType=problem-list-v2&envId=rdrp7yhj
SELECT product_id, store, price 
FROM Products
UNPIVOT (
    price FOR store IN (store1, store2, store3)
) AS unpivoting;
