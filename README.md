# JAMF-Extension-Attributes/Certificate

1) User Certificate Name+SHA1.sh
  Output :
    parna=125E595C3AB1294354622B71CE1940 
    bb.com=C86C637A64C41989FF5FFCF00

2) User Certificate Name+Expiration Date.sh
  Output :
    parna= 5-Mar-2023
    bb.com=22-Apr-2023

3) User All Matching Certificate Name+Expiration Date.sh
  Output :
    bb.com=22-Apr-2023
    958F-2C6496FECC65=22-Feb-2025
    nikandan R=20-Jan-2024
    bb.com=16-Nov-2023
    ndupatla= 5-Mar-2023
    bb.com=16-Nov-2023
   
4) User All Matching Certificate Name+Expiration Date(Date count).sh
  Output :
    bb.com=22-Apr-2023 (-203 days)
    958F-2C6496FECC65=22-Feb-2025 (+469 days)
    nikandan R=20-Jan-2024 (+70 days)
    bb.com=16-Nov-2023 (+5 days)
    ndupatla= 5-Mar-2023 (-251 days)
    bb.com=16-Nov-2023 (+5 days)
5) User All Matching Certificate Name+Expiration Date(Expiring in 30 days).sh
   Output :
   bb.com=16-Nov-2023 (+5 days)
   bb.com=16-Nov-2023 (+5 days)
