<div class="container">
	
<form name="choixTitu" id="choixTitu" action="index.php" method="POST">
	<h4>Choix du titulaire de {$groupe}</h4>
	{foreach from=$listeTitus key=acronyme item=unTitu}
		<input type="radio" name="acronyme[]" value="{$acronyme}" class="titulaire">{$unTitu} <br />
	{/foreach}
	<button type="submit" class="btn btn-primary" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="tituDeListe">
	<input type="hidden" name="groupe" value="{$groupe}">
</form>

</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){
	$(".titulaire").click(function(){
		$("#choixTitu").submit();
	})
	
	$("#choixTitu").submit(function(){
		var toto = $(".titulaire").val();
		alert(toto);
		if ($(".titulaire").val() == '') {
			return false
		}
		else 
		$("#wait").show();
		})
})

</script>