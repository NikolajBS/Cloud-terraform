OBJECTIVES:

Create group GCP project.
Create a Google Cloud Source Repository git repo and use it for the project together.

Fork this project to your own repositories and work in those together for the rest of the steps.

Invite team members to the project with relevant IAM roles assigned.

Create Terraform landing zone (initialize Terraform, connect with GCP backend) use Terraform for the next steps where it makes sense.

Create build pipeline for frontend and backend applications.

Change frontend app so that the backend address comes from configuration.

Deploy frontend application to Storage Bucket with web settings and publish it with CDN.

Deploy backend application to Cloud Run.

Create Cloud SQL MySQL instance.

Create connection between Cloud Run backend and the deployed MySQL instance.

Implement centralised logging and alerting on key metrics for the whole stack. 

Create detailed report about architecture and implementation choices. Include what you have learned from the leactures, industry talks, Terraform sessions and Google Cloud lectures and labs. Include your own considerations, and the different ways you tried to implement the objectives, and which worked and which did not. If you were not able to implement something with Terraform, list it, and give an explanation why, and how you did it in the end.

Write a summary of the main steps of your implementation to the README.md file under STEPS OF IMPLEMENTATION. Consider only the final solution's steps (don't include everything you tried, just what you hand in, so we can easily have an overview of your solution).

=== COMPLETE THE ABOVE FOR 4 ===

Use Secret Manager to store database sensitive information.
Take environment variables in the backend from Secret Manager for connecting to the DB.
Change frontend app build process so that the backend address comes from configuration.

=== COMPLETE THE ABOVE FOR 7 ===

Secure the frontend with HTTPS  add domain name.

OR
Implement storing food images, in a bucket and shows as the menu items (e.g. by acquiring images with a Cloud Function).

=== COMPLETE THE ABOVE FOR 10 ===

Secure connection between Cloud SQL and Cloud Run.

=== COMPLETE THE ABOVE FOR 12 ===

STEPS OF IMPLEMENTATION

- set up database in cloud SQL with private IP that is deployed to a custom network.

- Set up secrets to securely store sensitive database information. The values are read from a .tfvars file.

- Set up backend in cloud run with DB variables that are read from secrets. The backend is  also connected to the custom network using VPC connector.

- set up monitoring of central components and alert for high traffic on backend and database.

- added domain name to our frontend with load balancer, through map and proxy, and SSL to ensure encryption

- added bucket for frontend that has CDN enabled.

- passing backend URL dynamically to frontend from the cloud build

- pipeline builds for backend that pushes new image to GCR and tags with 'latest' and frontend that build and replaces frontend bucket with new deployment.

- set up terraform project in a modular way allowing the user to deploy environments in development/production

