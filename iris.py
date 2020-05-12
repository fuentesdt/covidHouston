
import pandas as pd
from bokeh.sampledata.iris import flowers

from bokeh.plotting import figure, show, save, output_file
from bokeh.models import ColumnDataSource, HoverTool


# load pandas
import pandas as pd 
# Read data from file 'filename.csv' 
# (in the same directory that your python process is based)
# Control delimiters, rows, column names with read_csv (see later) 
data = pd.read_csv("data.csv") 
# Preview the first 5 lines of the loaded data 
data.head()


colormap = {'setosa': 'red', 'versicolor': 'green', 'virginica': 'blue'}
#flowers['colors'] = [colormap[x] for x in flowers['species']]
data['colors'] = ['blue' for x in data['Day']]

hover = HoverTool(tooltips=[
    ("Day", "@Day"),
    ("Date", "@Date"),
    ("Peak Day", "@PeakDay"),
    ("Cases Reported", "@CasesReported"),
    ("Predicted Cases", "@PredictedValues"),
    ("Total Cases", "@TotalCases")
    ])

p = figure(title = "Houston Area Covid Data", plot_height=500, plot_width=500, tools=[hover, "pan,reset,wheel_zoom"])

p.xaxis.axis_label = 'Day'
p.yaxis.axis_label = 'Cases Reported'

p.circle('Day', 'CasesReported', color='colors', 
         fill_alpha=0.2, size=10, source=ColumnDataSource(data))

p.line('Day', 'PredictedValues', color='black', source=ColumnDataSource(data))

output_file('docs/bokeh/flowers.html')

#show(p)
save(p)
