var FilterableItemTable = React.createClass({

  render: function() {
    return (
      <div class="row">
        <div class="col-md-10 col-md-offset-1 col-xs-12">
          <div class="row">
            <ItemNavTabList intentions={this.props.intentions} />
            <ItemTabPaneSelector intentions={this.props.intentions} headers={this.props.headers} items={this.props.items} />
          </div>
        </div>
      </div>
    );
  }
});
