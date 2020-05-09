
datatmp.csv:
	python parse.py
docs/covidcurvefit.html: datatmp.csv
	matlab -nodisplay -nodesktop -r "opts.outputDir = 'docs'; opts.format = 'html'; publish('covidcurvefit',opts);quit";
	git commit -m 'daily update' . ; git push ;
docs/bokeh/flowers.html: datatmp.csv
	/opt/apps/miniconda/miniconda3/bin/python iris.py
