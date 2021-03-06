performPairwiseWilcoxTest <- function(dependentVariable, independentVariable, dataset, varianceEqual = "TRUE", paired = "FALSE", independentVariableName, dependentVariableName, levelA, levelB)
{
    dataset <- as.data.frame(dataset);
    
    dependentVariable <- c(dependentVariable);
    independentVariable <- c(independentVariable);   
    
    groupA = eval(parse(text = paste("subset(dataset, dataset$", independentVariableName," == \"", levelA, "\")", sep="")));
    groupA = eval(parse(text = paste("groupA$", dependentVariableName,sep="")));
    
    groupB = eval(parse(text = paste("subset(dataset, dataset$", independentVariableName," == \"", levelB, "\")", sep="")));
    groupB = eval(parse(text = paste("groupB$", dependentVariableName,sep="")));
    
    result = findError(c(list(groupA), list(groupB)));    
    error = result$error;
    
    result = pairwise.wilcox.test.with.statistic(dependentVariable, independentVariable, p.adjust="bonferroni", var.equal=T, paired=F);
    
    levels = eval(parse(text = paste("sort(unique(dataset$",independentVariableName,"))",sep="")));
    
    p = result[["p.value"]];
    pVal = 0;
    
    if(levelA == levels[length(levels)])
    {
        pVal = p[levelA, levelB];
    }
    else
    {
        if(levelA < levelB)
        {
            pVal = p[levelB, levelA];
        }
        else
        {
            pVal = p[levelA, levelB];
        }
    } 
    
    t = result[["U"]];
    tVal = 0;
    
    if(levelA == levels[length(levels)])
    {
        tVal = t[levelA, levelB];
    }
    else
    {
        if(levelA < levelB)
        {
            tVal = t[levelB, levelA];
        }
        else
        {
            tVal = t[levelA, levelB];
        }
    }
    
    g <- factor(c(rep("groupA", length(groupA)), rep("groupB", length(groupB))));
    v <- c(groupA, groupB);
    
    distributionType = "exact"
    if(length(groupA) > 100)
      distributionType = "approximate"
    
    result <- coin::wilcox_test(v~g, distribution = distributionType);
    
    Z = result@statistic@teststatistic[["groupA"]];
    
    r = Z/length(groupA);
    
    list(p = pVal, U = tVal, r = abs(r), error = error);
}