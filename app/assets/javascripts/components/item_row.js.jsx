var ItemRow = React.createClass({

  render: function() {
    var values = [];
    this.props.item.values.forEach(function(value) {
      values.push(<ItemRowValue value={value} />);
    });

    return (
      <tr>
        <td class="text-center">
          <div class="img-container">
            <a href="{this.props.item.itemPath}" class="img-rounded img-responsive img-raised">
              <img src="{this.props.item.photoUrl}"></img>
            </a>
          </div>
        </td>
        <td class="td-name">
          <a href="{this.props.item.itemPath}">{this.props.item.description}</a>
        </td>
        {values}
      </tr>
    );
  }
});
