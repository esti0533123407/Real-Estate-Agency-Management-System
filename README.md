# Real Estate Agency Management System

## Project Overview
This project is a full-stack web application developed as a preparation project for the final practicum course. The system provides a comprehensive management pipeline for real estate agencies, handling property listings, active agents, and the buying/renting lifecycles of various apartments.

To ensure consistency, security, and performance, the system is strictly built using a **Three-Layer Architecture**:

Angular Client ──> .NET Web API ──> SQL Server Database

>  **Important Constraint:** In compliance with the project specifications, all communication, queries, and data modifications within the database layer are performed **exclusively using Stored Procedures**. Direct inline SQL queries or generic table-level operations are not permitted.

---

## Technical Stack
* **Database:** Microsoft SQL Server
* **Backend Server:** .NET Web API (C#)
* **Frontend Client:** Angular (TypeScript)
* **Communication Protocol:** RESTful API via a Single Unified Endpoint

---

## System Architecture & Data Flow
The logical layout is structured into three highly decoupled layers:

1. **Client (Angular):** Responsible for managing the user interface, client-side routing, interactive forms, validation state, and handling asynchronous API dispatches.
2. **API (.NET Web API):** Serves as a secure processing layer. It intercepts incoming HTTP POST payloads from the client, extracts the targeting parameters, and delegates execution directly to the database layer.
3. **Database (SQL Server):** Persists all operational records and contains the core business logic wrapped inside compiled stored procedures.

**Workflow Diagram:**
Angular Frontend  ──>  .NET API Gateway  ──>  SQL Server Stored Procedure
▲                                                 │
└──────────────────  JSON Response  ──────────────┘

---

## Database Schema
The relational database layer consists of four primary tables:

### 1. `Apartments` (Main Ledger)
Stores data regarding the real estate assets.
* `ApartmentID` (Primary Key)
* `Title`
* `Description`
* `Price`
* `CityID` (Foreign Key ──> `Cities`)
* `StatusID` (Foreign Key ──> `Statuses`)
* `AgentID` (Foreign Key ──> `Agents`)
* `CreatedDate`

### 2. `Cities` (Lookup)
Defines supported geographical territories.
* `CityID` (Primary Key)
* `CityName`

### 3. `Statuses` (Lookup)
Maintains operational listing states (*e.g., For Sale, For Rent, Sold*).
* `StatusID` (Primary Key)
* `StatusName`

### 4. `Agents` (Registry)
Tracks real estate professionals managing the inventory.
* `AgentID` (Primary Key)
* `FullName`
* `Email`

---

## Stored Procedures Layer
All database interactions are abstracted behind dedicated database routines:

### Primary Operations
* `CreateApartment`: Inserts a new listing into the records.
* `UpdateApartment`: Commits modifications to an existing property's details.
* `GetApartmentById`: Returns detailed fields of a specific asset using structural `JOIN` blocks to fetch descriptive data for City, Status, and Agent.
* `GetAllApartments`: Returns a complete array of records supporting custom search terms and catalog filters.
* `DeleteApartment`: Removes a property from the active registry.

### Utility & Reference Lookups
* `GetAllCities`: Returns the complete lookup set for city components.
* `GetAllStatuses`: Returns available status metrics for listings.
* `GetAllAgents`: Fetches agent contact records to populate relational selectors.
* `GetApartmentsByAgent`: Filters the active inventory to show records belonging to a single agent.

---

## API Design & Unified Endpoint
To comply with the project guidelines, the .NET backend avoids split individual REST paths, exposing instead a **single dynamic POST route** that acts as an orchestration gateway:

### POST /api/exec

#### Request Structure
Clients push an instruction block containing the targeted procedure identifier accompanied by a dictionary of execution parameters.

#### Example Payload (JSON):
```json
{
  "procedureName": "CreateApartment",
  "parameters": {
    "Title": "Modern 3-Room Penthouse",
    "Description": "Spacious asset with a panoramic view, close to central transit.",
    "Price": 2450000,
    "CityID": 1,
    "StatusID": 2,
    "AgentID": 3
  }
}
