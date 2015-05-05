
function loadchart(chartdata)
{
    var datacolours=["green","yellow","red","lightblue"];
    var labels=["positive","negative","nothing"];

    var width = 500,
	height = 500,
	padding= 50;


    var chart = d3.select("#chart")
	.attr("width", width)
	.attr("height", height);


    var barWidth = (width-padding) / datacolours.length ;


    var yScale = d3.scale.linear()
	.domain([0, d3.max(chartdata)])
	.range([height-padding, padding]);

    //Define Y axis
    var yAxis = d3.svg.axis()
	.scale(yScale)
	.orient("left")
	.ticks(5);


    function trans(i)
    {
	return (i*barWidth)+padding;
    }

    var bar = chart.selectAll("g")
	.data(chartdata)
	.enter().append("g")
	.attr("transform", function(d, i) {return "translate(" + trans(i) + ",0)"; });

    bar.append("rect")
	.attr("y", function(d) { return yScale(d); })
	.attr("height", function(d) { return height - yScale(d) -padding; })
	.attr("width", barWidth - 1)
	.style("fill",function(d,i){return datacolours[i];});

    bar.append("text")
	.attr("x", barWidth / 2)
	.attr("y", function(d) { return yScale(d) + 3; })
	.attr("dy", ".75em")
	.text(function(d) { return d; });

    bar.append("text")
	.attr("x",0)
	.attr("y",height-padding)
	.attr("dy","0.75em")
	.text(function(d,i){return labels[i]});

    //Create Y axis
    chart.append("g")
	.attr("class", "axis")
	.attr("transform", "translate(" + padding + ",0)")
	.call(yAxis);

}



