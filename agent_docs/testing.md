#Testing

When writing tests, follow below behaviour:
1. Come up with test cases, following the Generating test cases section
2. Write tests for each test case, following the Testing rules section
3. Evaluate tests with the After writing tests section
4. If the evaluation shows that the tests are not sufficient, go back to step 1 and modify tests accordingly

Keep in mind that tests should be able to serve as documentation around the functionality being tested. Tests should not be excessive, since they introduce an overhead to CI/CD build times.

#### Generating test cases
Think about the following, without looking into the code implementation of the tested functionality.
1. What functionality should be tested? Have all edge cases been covered, and is the coverage sufficient?
2. What type of test should be used for each functionality? Unit, integration, or end-to-end?

#### Testing rules
- For similar tests with same concept being tested in different scenarios, use the unroll annotation
- Create new helper methods to instantiate business objects if needed
- Provide explanation for each given, when, then block
- Split blocks using and blocks if they are doing more than 1 thing
- Modify helper methods to add additional arguments if needed
- Each test should have a clear reason for existing that can be inferred from its title

#### After writing tests
Evaluate them with following criteria:
1. What is the functionality tested here? Is it business logic or infrastructure, or library code?
2. Is the coverage on the class sufficient or are there edge cases not covered?
3. Is the type of test correct (unit, integration, end-to-end)?
