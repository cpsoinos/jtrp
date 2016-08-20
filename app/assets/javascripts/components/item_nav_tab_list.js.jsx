var ItemNavTabList = React.createClass({

  render: function() {
    var tabs = [];

    _.each(this.props.intentions, function(value, key) {
      tabs.push(<ItemNavTab name={key} icon={value.icon} displayName={value.display_name} />);
    })
    return (
      <ul className="nav nav-pills nav-pills-icons nav-pills-primary text-center" role="tablist">
        {tabs}
      </ul>
    );
  }
});
