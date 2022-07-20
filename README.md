[![Travis build status](https://travis-ci.org/JustinMShea/ExpectedReturns.svg?branch=master)](https://travis-ci.org/JustinMShea/ExpectedReturns)

# GSoC-Expected-Returns-Ilmanen


## Background

A lack of portfolio diversification can severely impact the financial goals and 
long term plans for individual retirement accounts, University Endowment funds, 
and Municipal Pension funds alike. And as financial market tumult surrounding `CoVid-19` has 
revealed, many investors are often not as diversified as they initially believe. 
While advisors are adept at packaging various financial products into 
"diversified portfolios", relationships among various asset classes can change 
suddenly during times of market crisis, upending the very diversification
an otherwise meticulous crafted portfolio was built to provide. Why does 
diversification fail for so many precisely when it's most needed and what can be done? 

In this project, you shall explore and implement several potential solutions for
enhancing portfolio diversification with `R`, as discussed in one of the best 
investment references of the recent decade, 
[Expected Returns: _An Investors Guide to Harvesting Market Rewards_](https://www.wiley.com/en-us/Expected+Returns%3A+An+Investor%27s+Guide+to+Harvesting+Market+Rewards-p-9781119990727) by [Antti Ilmanen](https://www.aqr.com/About-Us/OurFirm/Antti-Ilmanen).

From the Description;

> This comprehensive reference delivers a toolkit for harvesting market rewards from a wide range of investments. Written by a world-renowned industry expert, the reference discusses how to forecast returns under different parameters. Expected returns of major asset classes, investment strategies, and the effects of underlying risk factors such as growth, inflation, liquidity, and different risk perspectives, are also explained. Judging expected returns requires balancing historical returns with both theoretical considerations and current market conditions. Expected Returns provides extensive empirical evidence, surveys of risk-based and behavioral theories, and practical insights.

The objective will be to reproduce key approaches suggested by the text and test performance on current market conditions with `R`. We will use functions found in popular `R` in finance packages such as `PerformanceAnalytics`, `FactorAnalytics`, and `PortfolioAnalytics`. 
In some cases, we will also need to write additional functions to streamline workflows and implement solutions.


## Areas of Interest

We'll focus on three broad sections with specific subsection to explore

- Approaches to Dynamic asset weighting
  * Value-oriented equity selection
  * Currency Carry
  * Commodity Momentum and Trend following
  
- Return Factors and their risk premia  
  * Inflation factor and inflation premium
  * Liquidity factor and illiquidity premium
  * Tail risks (volatility, correlation, skewness)

- Time-Varying Expected Returns
  * Endogenous return and risk: Feedback effects on expected returns
  * Tactical return forecasting models
  * Cyclical variation in asset returns


### Approaches to Dynamic asset weighting

**Value-oriented equity selection**, chapter 12.

On sector neutrality, style timing, and other refinements, see Asness et al. (2000),
Barberis–Shleifer (2003), Cohen–Polk–Vuolteenraho (2003), Qian–Hua–Sorensen
(2007), Lancetti–Nordquist (2008), Phalippou (2008), and Mezrich (2010).

On the link to distress and credit risk, see Campbell–Hilscher–Szilagyi (2008) 
and Avramov et al. (2010). 

On value strategy’s success outside equity selection, see Arnott–Hsu–West (2008), Asness–Moskowitz–Pedersen (2009), and Blitz–van Vliet (2009).

**Currency carry strategies**, Chapter 13.

The academic literature on currency carry had already begun by around 1980 but 
the renaissance occurred in recent years with notable papers by Lustig–Verdelhan 
(2007), Brunnermeier–Nagel–Pedersen (2008), Farhi et al. (2009), Jurek (2009), 
and Burnside et al. (2010a). 

Among practitioner work, see Bilson (1993) and Nordvig (2007). 

On other predictors than carry, see Ilmanen–Sayood (2002), Yilmaz (2009), and 
Ang–Chen (2010). 

On carry strategies in various asset classes, see Cochrane (1999), 
Asness–Moskowitz–Pedersen (2009), and Bacchetta–Mertens–van Wincoop (2009).

**Commodity Momentum and trend following**, Chapter 14.

Many authors have in recent years analyzed commodity momentum strategies: 
Erb–Harvey (2006), Ribeiro–Normand–Loeys (2006), Gorton–Hayashi–Rouwenhorst (2007), 
Miffre–Rallis (2007), Fuertes–Miffre–Rallis (2010), and Shen–Szakmary–Sharma (2010). 

For a broad survey, see Schneeweis–Kazemi–Spurgin (2008).

On momentum or trend-following strategies in broader contexts, see 
Asness–Liew–Stevens (1997), Griffin–Ji–Martin (2005), Bhojraj–Swaminathan (2006), 
Ribeiro–Loeys (2006), Blitz–van Vliet (2008), Pukthuanthong–Levich–Thomas (2007), 
Asness–Moskowitz–Pedersen (2009), and Moskowitz–Ooi–Pedersen (2010). 
The last two studies also review explanations of why these strategies work so well.

On lead–lag relations across economically related firms or countries, see 
Cohen–Frazzini (2008) and Rizova (2010).

### Return Factors and their risk premia

**Inflation factor and inflation premium**, Chapter 17

For a historical perspective on the inflation factor, see Ferguson (2007),
Greenspan (2007), and Reinhart–Rogoff (2008, 2009). 

On the economic impact of inflation, see Barro (1995). 

On the relation between inflation and equity returns, see Fama–Schwert (1979),
Modigliani–Cohn (1979), Boudoukh–Richardson (1993), Campbell–Vuolteenaho
(2004b), Piazzesi–Schneider (2007), Bekaert–Engstrom (2010), and Lee (2009). 

On different assets’ inflation-hedging abilities at various horizons, see Normand (2006),
Amenc–Martellini–Ziemann (2009), Briere–Signori (2009), Bekaert–Wang (2010), and
Martin (2010).

**Liquidity factor and illiquidity premium**, Chatper 18.

Given the growing interest on liquidity, an excellent survey by 
Amihud–Mendelson–Pedersen (2005) is gradually becoming outdated. 

On the relation of liquidity premia with business and monetary cycles, see 
Jensen–Moorman (2010) and Naes–Skjeltorp–Odegaard (2011). 

On time-varying liquidity premia, see Watanabe–Watanabe (2008). 

On market timing using liquidity indicators, see Guo et al. (2010). 

On the profits of liquidity provision strategies, see Nagel (2009) and Rinne–Suominen (2010).

On liquidity droughts, see Brunnermeier (2009), Brunnermeier–Pedersen (2009),
Garleanu–Pedersen (2009a), Nagel (2009), Pedersen (2009), and Duffie (2010).

**Tail risks (volatility, correlation, skewness)**, Chapter 19

On the time series relation between volatility and future market returns, see 
French–Schwert–Stambaugh (1987), Glosten–Jagannathan–Runkle (1993), Whitelaw (1994), Ghysels–Santa-Clara–Valkanov(2005), and Bollerslev–Zhou (2006).

On leverage constraints and the relative performance of low-beta and high-beta
assets, see Black (1972), Baker–Bradley–Wurgler (2010), and Frazzini–Pedersen (2010).

On correlation-related patterns, see Deng (2007), Driessen–Maenhout–Vilkov (2009),
Krishnan–Petkova–Ritchken (2008), Pollet–Wilson (2008) for equity markets and
Bhansali–Gingrich–Longstaff (2008), Longstaff–Rajan (2008), Coval–Jurek–Stafford
(2009) for debt markets. 

On hedge fund sensitivities to higher moments, see Bondarenko (2004), 
Agarwal–Bakshi–Huij (2007), Lo (2008), and Buraschi–Kosowski–Trojani
(2010). 

### Time-Varying Expected Returns

**Endogenous return and risk: Feedback effects on expected returns**, Chapter 20

On feedback effects that create endogenous return and risk, see Shiller (2000), 
Lo (2004), Soros (2008), Brunnermeier–Nagel–Pedersen (2008), Brunnermeier–Pedersen (2009), Danielsson–Shin–Zigrand (2009), Geanakoplos (2009), Summers (2009), and Shin (2010). 

On crowded trades, see Perold–Sharpe (1988), Khandani–Lo (2007), Pedersen (2009), 
and Stein (2009). 

On short-term momentum and long-term reversals, see Cutler–Poterba–Summers (1991) 
and Ghayur et al. (2010).

**Tactical return forecasting models**, Chapter 24: 

For examples of simple forecasting models in the bond market context, see
Ilmanen (1997), Ilmanen–Sayood (2002), and Naik–Balakrishnan–Devarajan (2009).

For an example of fair value models, see Panigirtzoglou–Loeys (2005). 

For books on quantitative forecasting models and trading approaches, all with 
equity orientation, see Grinold–Kahn (1999), Qian–Hua–Sorensen (2007), and 
Fabozzi–Focardi–Kolm (2010). 

On factor-mimicking portfolios, see Melas–Suryanarayanan–Cavaglia (2010). 

On econometric issues see Campbell–Lo–McKinlay (1996) and Cochrane (2005a).

**Cyclical variation in asset returns**, Chatper 26.

For examples of similar business cycle analysis, see Naik–Devarajan (2009) and 
Lustig–Verdelhan (2010). See Kaya–Lee–Pornrojnangkool (2010) and Ang–Bekaert 
(2002) for applications of regime-switching models. 


## References

[Ilmanen, Anti. 2011. “Expected Returns.” John Wiley & Sons Ltd. ISBN: 978-1-119-99072-7](https://www.wiley.com/en-us/Expected+Returns%3A+An+Investor%27s+Guide+to+Harvesting+Market+Rewards-p-9781119990727)

