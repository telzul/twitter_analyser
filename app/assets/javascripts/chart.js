function load_chart(chartdata) {
  var labels = ["positive", "negative", "nothing"];

  var margin = {
      top: 20,
      right: 30,
      bottom: 30,
      left: 30
    },
    width = 460 - margin.left - margin.right,
    height = 460 - margin.top - margin.bottom;


  var x = d3.scale.ordinal().rangeRoundBands([0, width], .05),
    y = d3.scale.linear().range([height, 0]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(10);

  var svg = d3.select("#chart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain(labels);
  y.domain([0, d3.max(chartdata, function(d){return d.value})]);

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .selectAll("text")
    .style("text-anchor", "end");

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Count");

  var bar = svg.selectAll("bar")
    .data(chartdata)
    .enter().append("g")
    .attr("class", "bar");

  bar.append("rect")
    .attr("x", function(d) {
      return x(d.sentiment);
    })
    .attr("width", x.rangeBand())
    .attr("y", function(d) {
      return y(d.value);
    })
    .attr("height", function(d) {
      return height - y(d.value);
    });

  bar.append("text")
    .attr("dy", ".75em")
    .attr("y", function(d){return y(d.value) - 13})
    .attr("x", function(d){return x(d.sentiment) + x.rangeBand()/2;})
    .attr("text-anchor", "middle")
    .text(function(d) { return d.value; });
}
