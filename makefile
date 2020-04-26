
datatmp.csv:
	python parse.py

docs/covidcurvefit.html: datatmp.csv
	matlab -nodisplay -nodesktop -r "opts.outputDir = 'docs'; opts.format = 'html'; publish('covidcurvefit',opts);quit";

dailyupdate: docs/covidcurvefit.html
	git commit -m 'daily update' . ; git push ;
