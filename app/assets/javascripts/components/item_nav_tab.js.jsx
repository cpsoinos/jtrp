var ItemNavTab = React.createClass({

  render: function() {
    var icon = this.props.icon;
    function createMarkup(icon) { return {__html: icon}; };
    return (
      <li class="">
        <a href={"#" + this.props.name} aria-controls="{this.props.name}" role="tab" data-toggle="tab" aria-expanded="false">
          <div dangerouslySetInnerHTML={createMarkup(icon)} />
          {this.props.displayName}
        </a>
      </li>
    );
  }
});
