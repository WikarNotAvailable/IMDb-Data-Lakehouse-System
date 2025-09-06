# IMDb-Data-Lakehouse-System
The aim of this project was to examine how data modeling influences Big Data processing and storage within modern data architectures. To achieve this, three data models with varying levels of schema normalization, 3NF, Star Schema, and One Big Table, were designed and implemented in the context of a Data Lakehouse.

An ELT process was carried out, and the data was organized following the Medallion architecture design pattern. Finally, the impact of data modeling was analyzed through categorized queries, and the results were validated.

**Technologies**

- Cloud environment: Microsoft Azure with Databricks
- Infrastructure provisioning: Terraform
- Programming language: Python
- Data processing: Pyspark
- Basic data visualizations: Power BI

**Data Source**

Data selected for the purpose of experiments and system testing come from the IMDb
website. https://datasets.imdbws.com/ 

This dataset is only a subset made for personal and non-commercial use, which means
it does not meet Big Data requirements in terms of data size. This is because the thesis
is not a commercial project, and the budget was very limited, requiring cost reductions.
However, the system architecture and the technology stack are strictly targeting Big Data
issues. Therefore, this dataset might be treated as the benchmark for the experiments.

**Architecture**
<img width="2169" height="1556" alt="archi (1)" src="https://github.com/user-attachments/assets/dc6fe2de-3a96-449f-b822-17a789d399b2" />

**Data Models**

3NF:

<img width="3488" height="3649" alt="3NF" src="https://github.com/user-attachments/assets/76068eb6-ef90-41b8-8c8b-39c7e5c60fb6" />

Star Schema:

<img width="2552" height="2098" alt="star1" src="https://github.com/user-attachments/assets/91335ebc-93fa-4c6f-aa8b-66a8d88abb9f" />

One Big Table:

<img width="400" height="800" alt="obt" src="https://github.com/user-attachments/assets/6aabd2fb-b773-413c-a7de-18486ff2fe03" />

**Examplary Visualizations**

<img width="948" height="400" alt="powerbi1 (1)" src="https://github.com/user-attachments/assets/14b75521-5b0d-4625-aa99-711535770e1a" />

<img width="590" height="904" alt="powerbi2 (1)" src="https://github.com/user-attachments/assets/e9e4a9fe-9232-4da4-8c79-c2a7afdd2762" />

<img width="929" height="485" alt="powerbi3 (1)" src="https://github.com/user-attachments/assets/ce37c89a-5b68-43b4-885a-d1cddba07060" />
