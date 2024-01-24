# plant_ordering_system

A new Flutter project.

Project Title : Plant Ordering System
Group 11  : Kiruthikga A/P Asogan (B032210042)
            Fatin Ainaa Syazwani Bt Mohd Refaee (B032210080) 
            Nur Amelia Asyqin Bt Mohd Ismailuzabihullah (B032210011)
            Israt Jahan Bhuiyan (B032020049)


For our projects there has two main terget users which is Admin and Customer.

We had created database which name  is (plant_ordering_system)

Table 
- customer
  - cust_id is being as FK to add_to_cart
- admin 
- plant 
   - plant_id is being as FK to add_to_cart table
- add_to_cart
   - cust_id - FK
   - plant_id - FK


Homepage 
- Here has user selection menu 
    - Customer
    - Admin

Admin Page
- Admin no need to register their account 
- Its already created    (username : admin123 , password : admin123)
- Admin can view list of customer details who registed 
- Admin can view the plants accoding to the plant type that already added to database
- Admin also can add plant's related details with upload plant image to database
- Admin can edit the related plant but must need to attact plant image
- If admin swipe left they can delete the plant to database but need to whether the plant not add to cart by customer
- There has navigation bar in bottom which is home and log out icon. 
    Home - admin home page
    Log out - can  from the admin page


Customer
- Customer can sign up their account 
- We added some validation control on the sign up form
- After successfully sign up customer required to log in their account
- Customer can view the plant list according to plant type that retrieve from database
- If customer click the plant image they can view the plant detailly then there customer can add to cart the plant desire.
- The added item will be saved into the database
- Before add to cart they can view the total payment which calculate from the quantity
- After add to cart they can view the add to cart item 
- If the customer add to cart the same plant its wil be merge and can view the total payment
- If the customer click procced to payment its will display receipt.
- There has navigation bar which is account icon in the bottom they can view the apps details and log out.
- And home icon is for customer homepage



REST APi
- We did _shareOnSocialMedia method 
   - Which in the admin after successsfuly added plant details its will display plant message to share to other social media platform.
- Currect DateTime
  -  Which wil display after customer procceed to the payment for the plant



