# Codes to analyze the different in Herbarium samples and freshly extracted samples 


# Q1: Does the year of collection differ between herbarium samples that worked and herbarium sample that didn't work 
d <- read.csv("Bromeliad_samples-collection_date.csv")
names(d)

groupN <- d$Collection.year[d$Workable..in.assembly.or.not. == "N"]
groupY <- d$Collection.year[d$Workable..in.assembly.or.not. == "Y"]

t.test(groupN,groupY,var.equal = FALSE) 
# Based on the t.test, the mean collection year of Yes group is 1992 
# and the mean collection year of N group is 1986. P-value is 0.243, suggesting no difference. 

lm1 <- lm(d$Collection.year ~ d$Workable..in.assembly.or.not.)
summary(lm1) 
# Based on the lm model, the p-value is 0.333, suggesting no difference 

# However, the sample size is too small and non-normally distributed, which might be baised. 

# I then did a boostrap test: 
B <- 5000
t_hat <- numeric(B)
# Bootstrap loop
for(i in 1:B){
  # 2. Draw a SRS of size n1/n2 from data, with replacement
  x1_star <- sample(groupN, size = length(groupN), replace = T)
  x2_star <- sample(groupY, size = length(groupY), replace = T)
  
  t_obs <- (mean(groupN) - mean(groupY))/
    sqrt(( sd(groupN) ^2/ length(groupN) ) +  sd(groupY) ^2/ length(groupY) )
  
  # 3. Calculate resampled mean and sd
  xbar1_star <- mean(x1_star)
  s1_star <- sd(x1_star)
  xbar2_star <- mean(x2_star)
  s2_star <- sd(x2_star)
  
  # 4. Calculate t_hat, and store it in vector
  t_hat_numer <- (xbar1_star-xbar2_star) - (mean(groupN)-mean(groupY))
  t_hat_denom <- sqrt((s1_star^2/length(groupN)) + (s2_star^2/length(groupY))) 
  
  t_hat[i] <- t_hat_numer / t_hat_denom
}

# Compute 1-sided p-value 

number_lower <- sum(t_hat < t_obs)
number_higher <- sum(t_hat > t_obs)

(p_boostrap_one <- 2*(min(number_lower, number_higher)/B)) # p-value = 0.2356

# Q2: Does the quality of assembly differ between herbarium samples that worked and fresh samples that worked?

# Below is the assembly result generated by Hybpiper stats 

# Below are some summary statistics without removing the not workable samples 
?read.table
a <- read.table("test_stats.txt", header = T) 
names(a)

t.test(a$NumReads) # get mean and CI 
t.test(a$GenesMapped)
t.test(a$GenesAt50pct)
t.test(a$GenesAt75pct)

# Below are some summary statistics after removing the non-workable samples 
nonworkable <- c(28, 35, 42, 43, 45, 46, 47, 48, 50, 51, 52, 54, 55)
b <- subset(a, !(Name %in% nonworkable))

t.test(b$NumReads)
t.test(b$GenesMapped)
t.test(b$GenesAt50pct)
t.test(b$GenesAt75pct)

# Test if the herbarium that worked differ in assembly quality with fresh samples 
b$herbORfresh <- "F"
herbarium <- seq(41,56,by=1)
herbarium <- subset(herbarium, !(herbarium %in% nonworkable))

b$herbORfresh[b$Name %in% herbarium] <-  "H"

names(b)
t.test(b$GenesMapped[b$herbORfresh == "F"], b$GenesMapped[b$herbORfresh == "H"])
t.test(b$GenesAt50pct[b$herbORfresh == "F"], b$GenesAt50pct[b$herbORfresh == "H"])
t.test(b$GenesAt75pct[b$herbORfresh == "F"], b$GenesAt75pct[b$herbORfresh == "H"])
t.test(b$NumReads[b$herbORfresh == "F"], b$NumReads[b$herbORfresh == "H"])
# There is no difference in the assembly quality between herbarium that worked and fresh materials 


