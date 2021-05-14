
$(document).ready(function() {
    var browse_all = "<span class=\"ml-2 \"><a class=\"browse-all\" href=\"/catalog\">Browse All</a></span>"

    // Required Reports page dataTable
    $('#required-report-table').DataTable({
        "info" : false,
        "dom" : 'ltp',
        "pagingType": "simple_numbers",
        "language": {
            "paginate": {
                "previous":"&laquo;",
                "next": "&raquo;"
            }
        },
        "initComplete": function( settings, json ) {
            $('#required-report-table_wrapper').removeClass("form-inline");

            this.api().columns('#agency').every( function () {
                var column = this;

                var select = $('<select class="f form-select"><option value="">Filter by Agency</option></select>')
                .appendTo( "#required-report-table_length" )
                .on( 'change', function () {
                    var val = $.fn.dataTable.util.escapeRegex($(this).val());
                    column
                        .search( val ? '^'+val+'$' : '', true, false )
                        .draw();
                });

                column.data().unique().sort().each( function ( d, j ) {
                    select.append( '<option value="'+d+'">'+d+'</option>' )
                });
            });
            $('.dataTables_length').addClass("d-flex");
        },
        "scrollX": false
    });

    $("div .f").wrap("<span class=\"ml-auto\"></span>");

    // Required reports page agency filter select box
    $('.f').select2();

    $('#recently_published_table').DataTable({
        "info" : false,
        "dom" : '<"d-flex"l<"ml-auto"f>>tp',
        "pagingType": "simple_numbers",
        "language": {
            "paginate": {
                "previous":"&laquo;",
                "next": "&raquo;"
            }
        }
        ,
        "initComplete": function( settings, json ) {
            $('#recently_published_table_wrapper').removeClass("form-inline");
            $('.pagination li:last-child').after(browse_all);
        }
    });
});

// Search results datatable
$(document).ready(function() {
    $('#search-results-table').DataTable({
        "info" : false,
        "dom" : '<"d-flex"l<"ml-auto"f>>t<"mt-2"p>',
        "pagingType": "simple_numbers",
        "language": {
            "paginate": {
                "previous":"&laquo;",
                "next": "&raquo;"
            }
        },
        "initComplete": function( settings, json ) {
            $('#search-results-table_wrapper').removeClass("form-inline");
        }
    });
});