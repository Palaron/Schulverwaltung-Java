$(document).ready(function()
		{
			$("#form").submit(function()
					{
						parent.closeDialog();
						this.submit();
					});
		}
);