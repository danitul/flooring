# Flooring

Matching a Customer to Partners

Our goal is to propose the right partner (a craftsman) to a customer based on
their project requirements. The last product category that we reworked was flooring. So the
goal is to propose the right partner based on the details of a customer's flooring project.

### Specifications 

#### User Story
As a house owner I want to get recommendations for craftsmen to do my flooring project so
that I will choose a reliable partner for a reasonable price to work with.

#### Acceptance Criteria
- The structure of the request from the customer (Client) is as follows
    - Material for the floor (wood, carpet, tiles)
    - Address (assume that this is the lat long of the house)
    - Square meters of the floor
    - Phone number (for the partner to contact the customer)
- The structure of the partner data is as follows:
    - Experienced in flooring materials (wood, carpet, tiles or any combination)
    - Address (assume that this is the lat long of the office)
    - Operating radius (consider the beeline from the address)
    - Rating (for this assignment you can assume that you already have average
rating for a partner)

- Matching a customer and partner should happen on the following criteria:
    - The partner should be experienced with the materials the customer requests
for the project
    - The customer is within the operating radius of the partner
- The customer should get a list of partners that offer the service
- The customer should be able to get the details of each partner that is suggested
- The list should be prioritized so the best match is shown first. The prioritisation of the
best match should be first by average rating and second by distance to customer.

## Implementation Assumptions and Considerations

### Computing the distance

I used the following formula for computing the distance between two (lat, lng) points:
```
d = acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lon1-lon2))
distance_km ≈ radius_km * distance_radians ≈ 6371 * d
```
For more details, see: https://stackoverflow.com/questions/5031268/algorithm-to-find-all-latitude-longitude-locations-within-a-certain-distance-fro

Also, using a geolocation gem such as https://github.com/geokit/geokit-rails
might prove useful, but didn't get to research it in more depth for this assignment as the current implementation seemed more straightforward.

### Assumptions

- A customer request implies only one type of material for a given floor area
- A partner can be an expert in one or more given materials
- The price is mentioned but is not included in the acceptance criteria, also not included here, should probably go to a different payment service anyway
- Regarding the matching a customer request to the partners controller action.
  There are different ways to design this. Without further information I chose to save a customer request in the db
 and then use it from there, instead of sending the required info through params.
 This assures me the data is supposed to be already validated.
  
### Testing
The application can be tested either by seeding the db with desired customer request and partners, and then calling the 'api/v1/partners/match/:customer_request_id'
or by writing more tests in the `partners_controller_test.rb` file