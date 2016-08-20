var ItemTable = React.createClass({

  render: function() {
    var headers = [];
    var rows = [];
    this.props.headers.forEach(function(header) {
      headers.push(<ItemTableHeader name={header} />);
    });
    this.props.items.forEach(function(item) {
      rows.push(<ItemRow item={item} />);
    })
    return (
      <table>
        <thead>
          <tr>{headers}</tr>
        </thead>
        <tbody>
          <tr>{rows}</tr>
        </tbody>
      </table>
    );
  }
});
