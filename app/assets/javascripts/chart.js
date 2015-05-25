function load_chart(chartdata) {
  var labels = ["positive", "negative", "nothing"];

  var margin = {
      top: 20,
      right: 80,
      bottom: 30,
      left: 80
    },
    width = 960 - margin.left - margin.right,
    height = 200 - margin.top - margin.bottom;


  var x = d3.scale.linear().range([0, width]),
    y = d3.scale.ordinal().rangeRoundBands([height, 0], 0.25);

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

  y.domain(labels);
  x.domain([0, d3.max(chartdata, function(d) {
    return d.value
  })]);

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")

  var bar = svg.selectAll("bar")
    .data(chartdata)
    .enter().append("g")
    .attr("class", "bar");

  bar.append("rect")
    .attr("x", function(d) {
      return 0;
    })
    .attr("width", function(d) {
      return x(d.value);
    })
    .attr("y", function(d) {
      return y(d.sentiment);
    })
    .attr("height", y.rangeBand())
    .attr("class", function(d) {
      return d.sentiment;
    });
  bar.append("text")
    .attr("dy", ".75em")
    .attr("y", function(d) {
      return y(d.sentiment) + 12
    })
    .attr("x", function(d) {
      return x(d.value) + y.rangeBand() / 2;
    })
    .attr("text-anchor", "middle")
    .text(function(d) {
      return d.value;
    });
}
