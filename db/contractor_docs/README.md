# Contractor Notes

**Note: Whenever there's a DB update, it should be accompanied by a "Date" log**

## Date: 2026-10-10

#### `users` table


Standard "user" model to represent any entity that has access to the application


#### `roles` & `role_assignments` tables


There are many roles to describe a user. These include `coordinator`, `patient`,
and `caregiver`. We could have added a `role` field to the `users` table, but
that wouldn't scale well since users may need to have multiple roles in
the future. For instance, one can be a `coordinator` and some other access
specific role. Thus `roles through role_assignments` relationship is the model
we chose to represent role specific access for a user 

#### `patients`, `caseload_assignments`, & `caregiver_assignments` tables

The initial thought was to distinguish patients using user accounts and roles,
but this hit a snag because of the patient/caregiver relationship. A caregiver
can act on behalf of a patient, but a patient and caregiver should have separate,
independent accounts. Thus we needed to identify a patient separately, where
a user can be assigned to many patients (i.e. has_many patients). Thus a
coordinator (via `caseload_assignment`) and caregiver (via `caregiver_assignment`)
can be assignment to multiple patients. This also streamlines querying
records that a user can access. These also are `has_many through` relationships
in the user and patient models

A user/caregiver `has_many :caregiver_assignments` and `has_many :cared_for_patients, through: :caregiver_assignments, source: :patient`.

A user/coordinator `has_many :caseload_assignments` and `has_many :assigned_patients, through: :caseload_assignments, source: :patient`.

#### `medications`& `medication_logs` tables

A big part of the coordinator's job is to track medication adherence. A physician
can prescribe medication and the coordinator monitors assigned patients for
adherence. Thus the coordinator needs to be alert when medication is not taken.

For medication, we decided to include the following fields:
+ name
+ dosage
+ frequency_unit
+ frequency_interval
+ doses_per_interval
+ etc...

This allows for granular details to be included. Essentially, how much and how often
to take medication. Medication belongs to a patient. We have `prescribed_by_name`
as a temporary placeholder for this assignment. But, in practice, it should be
`prescribed_by_user_id` which maps to the `User` model. Given prescriptions are
done by doctors or RNs, and they are not included in this task, we're using
the placeholder for now. Thus, for a real application, there woudld be a `belongs_to :user`
relationship as well

`medication_logs` are the interval records of medication taking adherence. A caregiver
or patient can log adherence. This allows coordinators to monitor who's on track
and who isn't on track via fields such as `status`, and `recorded_by`.

##### Extra task

The above leads to the following task constraint.

```
* Patients can request deletion of their account and history at any time. Coordinators rely on historical adherence trends to spot patterns over time. Both of those are true requirements. We haven't resolved the tension between them, and neither should you feel you need to fully resolve it. Either ask a clarifying question or state the assumption you're making and move on.
```

A patient can delete their account and history while coordinators have access to historical adherence trends. This can be
done simply using anonymizing aggregations. In other words, the aggregated data does not tie to a specific patient. It's
simply a nameless trend that coordinators can analyze. Of course, data structure will be important, but
the aggregated snapshot can be generated on a consistence cadence (daily, every other day, etc...). This is
a common practice to retain useful analytics while preserving a user's right to have their specific
identifying data removed.










