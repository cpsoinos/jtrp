var ItemTabPane = React.createClass({

  render: function() {
    return (
      <div class="large-top-margin">
        <div class="tab-content">
          <div role="tabpanel" class="tab-pane fade" id="{this.props.intention}">
            <ItemTable headers={this.props.headers} items={this.props.items} />
          </div>
        </div>
      </div>
    );
  }
});
