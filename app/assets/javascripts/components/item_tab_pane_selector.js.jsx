var ItemTabPaneSelector = React.createClass({

  render: function() {
    var panes = [];
    var headers = this.props.headers;
    var items = this.props.items;

    _.each(this.props.intentions, function(value, key) {
      panes.push(<ItemTabPane intention={key} headers={headers} items={items} />);
    })



    return (
      {panes}
    );
  }
});
