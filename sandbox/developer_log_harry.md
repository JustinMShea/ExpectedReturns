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