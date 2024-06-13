## 5/30/2024
- Meeting with Brian to discuss short-term plan and medium-term objectives
	- Shifting from descriptive to predictive models by integrating ML frameworks
	- Integrate more model diagnostics (especially time-series tests)

## 5/31/2024
- Begin literature review with general surveys of the application of ML techniques to factor models and asset pricing
- Existing literature highlights various time-dependence problems with financial economics and predictive regression.
- *Note to self*: As we break down the project into smaller components, we can make decisions where we can integrate existing packages and where we should write our own. The three main components are: data preprocessing, model training, and model evaluation.

## 6/2/2024
- Looked at the MLR3 and TSTest packages.
- Will review the papers cited in TSTest to see how and when we can integrate and implement these
- To be discussed with mentors: MLR3 has a good framework but depending on what we want to do it may not be the most efficient way to do it. Since MLR3 calls external packages for the ML algorithms and we may want to do a lot of preprocessing and evaluation in house, may be more efficient for us to be more flexible.

## 6/4/2024
- Met with mentors and discussed how we want to envision future pipeline, do we try to integrate MLR3 or design our own pipeline
- Decided the way to test this is to write sample codes using both approaches

## 6/7/2024
- Work on simple ML codes as discussed in last meeting
- Getting started with MLR3 took a while but the process gets a bit easier once I start using it more
- At this stage, depending on how MLR3's extralearner package turns out (that package is still being finalized), we may stick with MLR3
- MLR3's documentation is sometimes lacking, so when we integrate I think there are a few things we want to keep in mind
	- We may need to rely more on in-house functions for data-preprocessing since there are some unique steps we may want to take with financial time-series data
	- We can rely on MLR3 for most of the ML algorithms but we may want to have some documentations just for ourselves for smoother implementation
	- Sometimes we will build our own prediction and evaluation functions. Sometimes MLR3 does quirky things with prediction so I will look more under the hood

## 6/8/2024
- Applied two elastic net algorithm by Rapach and Zhou (2019). Results are not great since there were some data constraints. The intention was not to prove how well model can perform but just to test the performances.
- At this stage I thinking using MLR3 should help with our workflow, but because time-series machine learning can be a bit different. MLR3Temporal is still under development and I am not sure how reliable it will be (has not been updated in a year)

## 6/10/2024
- Met with mentors
	- Agreed to integrate MLR3 into our proposed pipeline
	- Task: create a updated timeline by June 13 over the next two months or so

## 6/12/2024
### Conceptualization of pipeline

**Preprocessing**
- *How well-processed do we want our input data to be?*
- Handle missing values
- Handle outliers (detect and winsorize)
- Factor scaling
- Feature selection - removing unhelpful predictors or overly correlated features
- Creating useful labels
- Splitting data and preparing data for ML algorithms

**Calling Learners and Make Predictions**
- Integrate MLR3 algorithms
	- Make the process more transparent, we need to do more and better documentations
- Create/integrate pipelines for fine-tuning hypermarameters

**Model Evaluation**
- Create relevant benchmarks to compare model performance
	- Consider nonparametric outputs
- Time series tests
	- Integrate TStest package
- Present model interpretability
	- Make output (visualization) of model decisions/parameters
	- Allow users to evaluate whether these outputs make economic senses - this is probably most easy to see for tree-based models but can be generalized

### Short to Medium Term Plan
**Day 1-2**
- Create a minimum-viable pipeline
	- Create a test dataset
	- Define one regression and one classification task
	- Define one benchmark for each task for performance comparison
	- Create a few (3-4) relative and absolute metrics for evaluation

**Day 3-14**
 - Integrate selected MLR3 algorithms
	- Provide documentation for model specification, parameter inputs, and outputs
	- Budget time for 1-2 learners per day
	- For each learner/family of learner, I will identify relevant papers, see how these algorithms are implemented and make necessary adjustments
	- I will also read the documentations by MLR3 and the package it calls to better understand the parameters for the fine-tuning stage

**Day 15-20**
- Writing/integrating functions for preprocessing
	- Motivate preprocessing steps with existing literature
	- 1 type/family of preprocessing per day
	- If we decide to implement more features, we can extend this period as well

**Day 21-25**
- Model Interpretability
	- Visualize model outputs
	- If the model gives us weights, we can use bootstrap to get a confidence interval of weights distribution
	- If the model gives us something else, such as feature prominence and salience, we can also find ways to visualize them

**Day 26-30**
- Integrate TStest package and potential some more time-series tests
- Apply additional tests such as scenario analysis and stress test to see how well the model perform under different scenarios
	- The idea is that the model may have limited applications - specific factors may have stronger predictive power in some states than others

**Day 30-40**
- Write functions for more learners that are not available in the MLR3 framework(*If there are specific models we want to implement/test based on existing literature*)
- Test pipelines with various data/tasks to evaluate performance and identify areas of improvements