### 5/30/2024
- Meeting with Brian to discuss short-term plan and medium-term objectives
	- Shifting from descriptive to predictive models by integrating ML frameworks
	- Integrate more model diagnostics (especially time-series tests)

### 5/31/2024
- Begin literature review with general surveys of the application of ML techniques to factor models and asset pricing
- Existing literature highlights various time-dependence problems with financial economics and predictive regression.
- *Note to self*: As we break down the project into smaller components, we can make decisions where we can integrate existing packages and where we should write our own. The three main components are: data preprocessing, model training, and model evaluation.

### 6/2/2024
- Looked at the MLR3 and TSTest packages.
- Will review the papers cited in TSTest to see how and when we can integrate and implement these
- To be discussed with mentors: MLR3 has a good framework but depending on what we want to do it may not be the most efficient way to do it. Since MLR3 calls external packages for the ML algorithms and we may want to do a lot of preprocessing and evaluation in house, may be more efficient for us to be more flexible.

### 6/4/2024
- Met with mentors and discussed how we want to envision future pipeline, do we try to integrate MLR3 or design our own pipeline
- Decided the way to test this is to write sample codes using both approaches

### 6/7/2024
- Work on simple ML codes as discussed in last meeting
- Getting started with MLR3 took a while but the process gets a bit easier once I start using it more
- At this stage, depending on how MLR3's extralearner package turns out (that package is still being finalized), we may stick with MLR3
- MLR3's documentation is sometimes lacking, so when we integrate I think there are a few things we want to keep in mind
	- We may need to rely more on in-house functions for data-preprocessing since there are some unique steps we may want to take with financial time-series data
	- We can rely on MLR3 for most of the ML algorithms but we may want to have some documentations just for ourselves for smoother implementation
	- Sometimes we will build our own prediction and evaluation functions. Sometimes MLR3 does quirky things with prediction so I will look more under the hood