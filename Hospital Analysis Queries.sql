select * from visits;
select * from patients;
select * from doctors;

-- We have 3 tables visits,Doctors,Patients i am going to perform some anlaytical query for ease and get the exact data which is needed

-- Q1 Show all the visits with patients and doctors
SELECT v.VisitID, v.VisitDate, v.BillAmount, v.PaymentStatus,
       p.PatientName, p.Gender, p.Age, p.City, p.DiseaseCategory,
       d.DoctorName, d.Specialty
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
JOIN doctors d ON v.DoctorID = d.DoctorID;

/* In above query we can see in visits table there are 3 columns as (visitsID,patientID,doctorID) in which 
visitID is the primary key and patientID,doctorID acts as a foreign key in visits table.
The priamry key in doctors table is doctorID.
The primary key in patients table is patientID.*/

-- Q2 Total patients per gender
SELECT Gender, COUNT(*) AS TotalPatients
FROM patients
GROUP BY Gender;



-- Q3 Total visits per doctor?
SELECT d.DoctorID, d.DoctorName, d.Specialty, COUNT(v.VisitID) AS TotalVisits
FROM visits v
JOIN doctors d ON v.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.DoctorName, d.Specialty
ORDER BY TotalVisits DESC;

-- Q4 Total visits per city
SELECT p.City, COUNT(v.VisitID) AS TotalVisits
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
GROUP BY p.City
ORDER BY TotalVisits DESC;


-- Q5 Total patients per doctor?
SELECT d.DoctorID,d.DoctorName, d.Specialty,count( Distinct v.PatientID) as total_patients
FROM visits v
JOIN doctors d ON v.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.DoctorName, d.Specialty
ORDER BY Total_patients DESC;


-- Q6 Total revenue per doctor
SELECT d.DoctorName, d.Specialty, SUM(v.BillAmount) AS TotalRevenue
FROM visits v
JOIN doctors d ON v.DoctorID = d.DoctorID
GROUP BY d.DoctorName, d.Specialty
ORDER BY TotalRevenue DESC;

-- Q7 Total revenue per speciality
SELECT  d.Specialty, SUM(v.BillAmount) AS TotalRevenue
FROM visits v
JOIN doctors d ON v.DoctorID = d.DoctorID
GROUP BY  d.Specialty
ORDER BY TotalRevenue DESC;


-- Q8 Unpaid bills by patients (same you can find it for paid and insurance too) 
SELECT p.PatientName, p.City, SUM(v.BillAmount) AS UnpaidAmount
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
WHERE v.PaymentStatus = 'Unpaid'
GROUP BY p.PatientName, p.City
ORDER BY UnpaidAmount DESC;

-- Q9 Most comman disease category treated
SELECT p.DiseaseCategory, COUNT(v.VisitID) AS VisitCount
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
GROUP BY p.DiseaseCategory
ORDER BY VisitCount DESC;

-- Q10 Top 5 Doctors with highest revenue
SELECT d.DoctorName, d.Specialty, SUM(v.BillAmount) AS TotalRevenue
FROM visits v
JOIN doctors d ON v.DoctorID = d.DoctorID
GROUP BY d.DoctorName, d.Specialty
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Q11 What will be the average bill per disease category?
SELECT p.DiseaseCategory, AVG(v.BillAmount) AS AvgBill
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
GROUP BY p.DiseaseCategory
ORDER BY AvgBill DESC;

-- Q12 Total revenue contribution by payment status in percentage?
SELECT v.PaymentStatus, SUM(v.BillAmount) AS TotalRevenue,
       ROUND(100.0 * (sum(v.BillAmount) / (SELECT SUM(BillAmount) FROM visits)), 2) AS PercentageContribution
FROM visits v
GROUP BY v.PaymentStatus
ORDER BY TotalRevenue DESC;

-- Q13 categorize the data based on age group and find the visits per age group;
SELECT 
    CASE 
        WHEN p.Age < 18 THEN 'Child (0-17)'
        WHEN p.Age BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN p.Age BETWEEN 36 AND 55 THEN 'Middle Age (36-55)'
        WHEN p.Age BETWEEN 56 AND 75 THEN 'Senior (56-75)'
        ELSE 'Elderly (76+)'
    END AS AgeGroup,  COUNT(v.VisitID) AS TotalVisits
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
GROUP BY AgeGroup
ORDER BY TotalVisits DESC;




