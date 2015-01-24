
function loadchart(chartdata)
{
var datacolours=["green","brown","red","blue"];

var width = 300,
    height = 300;


var chart = d3.select("#chart")
    .attr("width", width)
    .attr("height", height);

var barWidth = width / datacolours.length;

var y = d3.scale.linear()
    .domain([0, d3.max(chartdata)+(Math.round(d3.max(chartdata)/10))])
    .range([height, 0]);

    var bar = chart.selectAll("g")
      .data(chartdata)
    .enter().append("g")
      .attr("transform", function(d, i) {console.log(i*barWidth); return "translate(" + i * barWidth + ",0)"; });

  bar.append("rect")
      .attr("y", function(d) { return y(d); })
      .attr("height", function(d) { return height - y(d); })
      .attr("width", barWidth - 1)
      .style("fill",function(d,i){return datacolours[i];});

  bar.append("text")
      .attr("x", barWidth / 2)
      .attr("y", function(d) { return y(d) + 3; })
      .attr("dy", ".75em")
      .text(function(d) { return d; });
}



