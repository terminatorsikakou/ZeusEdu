<div class="container">

<div class="row">

    <div class="col-md-6 col-sm-12">

    <h2>Les élèves que je suis</h2>

        <table class="table table-hover table-condensed">
            <thead>
                <tr>
                    <th style="width:1em">&nbsp;</th>
                    <th style="width:3em">&nbsp;</th>
                    <th>Classe</th>
                    <th>Nom</th>
                    <th>Date et heure</th>
                </tr>
            </thead>
            <tbody>
            {foreach from=$elevesSuivis key=matricule item=unEleve}
                {assign var=n value=0}
                {foreach from=$unEleve key=date item=uneVisite}

                <tr
                    class="{if ($uneVisite.absent == 1)}absent {/if}{if $n > 0}more_{$matricule}{/if}"
                    {if $n > 0} style="display: none"{/if}>
                    <td>
                        {if $n == 0}
                            <form action="index.php" method="POST" role="form" class="form-inline microform">
                                <input type="hidden" name="matricule" value="{$uneVisite.matricule}">
                                <input type="hidden" name="action" value="ficheEleve">
                                <button type="submit" class="btn btn-primary btn-xs"><i class="fa fa-eye"></i></button>
                            </form>
                        {else}
                            &nbsp;
                        {/if}
                    </td>
                    <td>
                        {if ($n == 0) && ($unEleve|@count > 1)}
                            <button
                                type="button"
                                class="btn btn-default btn-xs more"
                                data-matricule="{$uneVisite.matricule}"
                                data-open="0">
                                <i class="fa fa-arrow-circle-down"></i>
                                <span class="badge">{$unEleve|count}</span>
                            </button>

                        {else}
                            &nbsp;
                        {/if}
                    </td>
                    <td>{$uneVisite.groupe}</td>
                    <td
                        class="pop"
                        data-toggle="popover"
                        data-content="<img src='../photos/{$uneVisite.photo}.jpg' alt='{$uneVisite.matricule}' style='width:100px'>"
                        data-html="true"
                        data-container="body"
                        data-original-title="{$uneVisite.photo}">
                    {$uneVisite.prenom} {$uneVisite.nom}
                    </td>
                    <td>Le {$date} à {$uneVisite.heure}</td>
                </tr>
                {assign var=n value=$n+1}
                {/foreach}

            {/foreach}

            </tbody>
        </table>

    </div>  <!-- col-md-... -->

    <!-- <div class="col-md-6 col-sm-12">
        <div class="panel panel-info">
          <div class="panel-heading">
            <h3 class="panel-title">Mon calendrier</h3>
          </div>
          <div class="panel-body">

            <div id="calendar"></div>

          </div>
          <div class="panel-footer">

          </div>
        </div>

    </div> -->

</div>

</div>

<script type="text/javascript">

$(document).ready(function(){

    $(".more").click(function(){
        var matricule = $(this).data('matricule');
        var open = $(this).data('open');
        if (open == 0){
            $(this).find('i').removeClass('fa-arrow-circle-down').addClass('fa-arrow-circle-up');
            $(".more_"+matricule).fadeIn(1000);
            $(this).data('open',1);
            }
            else {
                $(this).find('i').removeClass('fa-arrow-circle-up').addClass('fa-arrow-circle-down');
                $(".more_"+matricule).fadeOut(1000);
                $(this).data('open',0);
            }
    })

    $("#calendar").fullCalendar({
		events: {
			url:'inc/calendar/events.json.php'
		},
		eventLimit: 2,
		header: {
		left: 'prev, today, next',
		center: 'title',
		right: 'month,agendaWeek,agendaDay'
		},
		eventClick: function(calEvent, jsEvent, view) {
			var id = calEvent.id; // l'id de l'événement
			var startDate = moment(calEvent.start).format('YYYY-MM-DD HH:mm');  // la date de début de l'événement
			// mémoriser la date pour le retour
			$("#startDate").val(startDate);
			var viewState = $("#viewState").val();
			$.post('inc/getTravail.inc.php', {
				event_id: id
				},
				function (resultat){
					$('#unTravail').fadeOut(400,function(){
						$('#unTravail').html(resultat);
					});
					$('#unTravail').fadeIn();
					$('#calendar').fullCalendar('gotoDate', startDate);
					$('#calendar').fullCalendar('changeView', viewState);
					}
				)
			},
		eventConstraint:{
	        start: '08:00:00',
	        end: '19:00:00'
	        },
		defaultTimedEventDuration: '00:50',
		eventResize: function(event, delta, revertFunc) {
			var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
			var endDate = moment(event.end).format('YYYY-MM-DD HH:mm');
			// mémoriser la date, pour le retour
			$("#startDate").val(startDate);

			var id = event.id;
			$.post('inc/getDragDrop.inc.php',{
				id: id,
				startDate: startDate,
				endDate: endDate
				},
				function (resultat){
					$("#unTravail").html(resultat);
					}
				)
			},
		eventDrop: function(event, delta, revertFunc) {
			var startDate = moment(event.start).format('YYYY-MM-DD HH:mm');
			// mémoriser la date pour le retour
			$("#startDate").val(startDate);
			// si l'événement est draggé sur allDay, la date de fin est incorrecte
			if (moment.isMoment(event.end))
				var endDate = moment(event.end).format('YYYY-MM-DD HH:mm');
				else var endDate = '0000-00-00 00:00';

			var id = event.id;
			var viewState = $("#viewState").val();
			$.post('inc/getDragDrop.inc.php',{
				id: id,
				startDate: startDate,
				endDate: endDate
				},
				function (resultat){
					$("#unTravail").html(resultat);
					$('#calendar').fullCalendar('gotoDate', startDate);
					$('#calendar').fullCalendar('changeView', viewState);
					}
				)
			},
		viewRender: function(event){
			var state = event.name;
			$("#viewState").val(state);
			},
		businessHours: {
			start: '08:15',
			end: '19:00',
			dow: [ 1, 2, 3, 4, 5 ]
			},
		minTime: "08:00:00",
		maxTime: "22:00:00",
		firstDay: 1
        //,
		// dayClick: function(date,event,view) {
		// 	var startDate = moment(date).format('YYYY-MM-DD HH:mm');
		// 	if (view.type == 'agendaDay') {
		// 		var heure = moment(date).format('HH:mm');
		// 		var dateFr = moment(date).format('DD/MM/YYYY');
		// 		var viewState = $("#viewState").val();
		// 		// mémoriser la date pour le retour
		// 		$("#startDate").val(startDate);
		// 		// est-ce une notification par classe ou par cours?
		// 		var type = ($("#selectClasse").val() == undefined)?'cours':'classe';
		// 		if (type == 'cours')
		// 			var destinataire = $("#coursGrp").val();
		// 			else if (type == 'classe')
		// 					var destinataire = $("#selectClasse").val();
		// 		var lblDestinataire = $("#lblDestinataire").val();
		// 		$.post('inc/calendar/getAdd.inc.php', {
		// 			startDate: startDate,
		// 			viewState: viewState,
		// 			heure: heure,
		// 			type: type,
		// 			destinataire: destinataire,
		// 			lblDestinataire: lblDestinataire
		// 			},
		// 			function(resultat) {
		// 				$("#zoneMod").html(resultat);
		// 				$("#modalAdd").modal('show');
		// 				$('#calendar').fullCalendar('gotoDate', startDate);
		// 				$('#calendar').fullCalendar('changeView', viewState);
		// 				}
		// 			)
		// 		}
		// 		else {
		// 			$('#calendar').fullCalendar('gotoDate', startDate);
		// 			$('#calendar').fullCalendar('changeView', 'agendaDay');
		// 		}
		// 	}

		});

})

</script>
