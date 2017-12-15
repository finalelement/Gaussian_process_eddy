function gpr_trial_1

    % Simulate Data
    n = 1000;
    x = linspace(-10,10,n)';
    y = 1 + x*5e-2 + sin(x)./x + 0.2*randn(n,1);
    
    % Fit a linear exponential, no nonsense
    fitresult = fit(x,y,'exp1');
    p11 = predint(fitresult,x,0.95,'observation','off');
    subplot(2,1,1)
    plot(fitresult,x,y), hold on, plot(x,p11,'m--')
    
    % Fit Gaussian Process
    gprMdl2 = fitrgp(x,y,'KernelFunction','squaredexponential');
    subplot(2,1,2)
    % Figure out why confidence interval does not work here
    %p12 = predint(gprMdl2,x,0.95,'observation','off');
    [ypred2,ysd,yint] = resubPredict(gprMdl2);
    plot(x,y,'b.')
    hold on
    plot(x,yint,'g')
    plot(x,ypred2,'r')
    
end
