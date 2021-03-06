<div class="row">

    <div class="col-md-6 col-sm-12">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Attribution des locaux {$date}</h3>
                </div>
                <div class="panel-body">

                    <form action="index.php" method="POST" class="form-vertical" role="form">
                        <div style="height:30em; overflow:auto">
                            <table class="table table-condensed">
                                <thead>
                                    <th>Abr</th>
                                    <th>Nom</th>
                                    <th style="width:10em">Local</th>
                                    <th>&nbsp;</th>
                                </thead>

                                <tbody>
                                    {foreach from=$locaux key=acronyme item=data}
                                    <tr>
                                        <td>{$acronyme}</td>
                                        <td>{$data.nom} {$data.prenom}</td>
                                        <td>
                                            <input type="text" name="local_{$acronyme}" value="{$data.local}" class="form-control">
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-default down" data-local="{$data.local}" title="recopier vers le bas">
                                                <i class="fa fa-arrow-down"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>

                            </table>
                        </div>
                        <!-- overflow -->

                        <div class="btn-group pull-right">
                            <button type="reset" class="btn btn-default">Annuler</button>
                            <button class="btn btn-primary" type="submit">Enregistrer</button>
                        </div>

                        <div class="clearfix"></div>
                        <input type="hidden" name="date" value="{$date}">
                        <input type="hidden" name="action" value="{$action}">
                        <input type="hidden" name="mode" value="enregistrer">
                        <input type="hidden" name="etape" value="locaux">

                    </form>

                </div>
                <div class="panel-footer">

                </div>

            </div>
            <!-- col-md-... -->

        </div>

</div>

<script type="text/javascript">
    $(document).ready(function() {

        $(".down").click(function() {
            var local = $(this).data('local');
            suivant = $(this).closest('tr').next();
            suivant.find('input:text').val(local);
            suivant.find('button').data('local', local);
        })
    })
</script>
