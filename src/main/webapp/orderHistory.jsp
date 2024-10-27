<%@ include file="header.jsp" %>

    <style>
        .btn-black {
            background-color: #000;
            color: #fff;
        }

        .btn-black:hover {
            background-color: #444;
            color: #fff;
        }

        .table th, .table td {
            text-align: center;
            vertical-align: middle;
        }

        .order-history-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 32px;
            color: #ca1515;
            background-color: #f8f9fa;
            padding: 10px 20px;
            border-radius: 50px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* Modal Styles */
        .modal-body {
            max-height: 400px;
            overflow-y: auto;
        }

        .btn-cancelled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .btn-cancelled:hover {
            background-color: #6c757d;
        }
    </style>

<body>
<div class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__links">
                    <a href="/"><i class="fa fa-home"></i> Home</a>
                    <span class="order-history-title">Order history</span>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="alert alert-success alert-dismissible fade" role="alert" id="successAlert" style="display:none;">
    <strong>Success!</strong> <span id="successMessage"></span>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="alert alert-danger alert-dismissible fade" role="alert" id="errorAlert" style="display:none;">
    <strong>Error!</strong> <span id="errorMessage"></span>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="container mt-5">
    <div class="row mt-4">
        <table class="table table-striped" id="ordersTable">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Created Date</th>
                    <th>Destination</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="ordersTableBody">
                <!-- Orders will be dynamically inserted here -->
            </tbody>
        </table>
        <p id="noOrdersMessage" style="display: none;">No orders found for this customer.</p>
    </div>
</div>

<div class="modal fade" id="orderDetailsModal" tabindex="-1" role="dialog" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailsModalLabel">Order Items</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <table class="table table-bordered">
                    <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                    </tr>
                    </thead>
                    <tbody id="order-items-body">
                    <!-- Order items will be injected here -->
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Cancellation Confirmation Modal -->
<div class="modal fade" id="cancelOrderModal" tabindex="-1" role="dialog" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cancelOrderModalLabel">Confirm Cancellation</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to cancel this order? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirm-cancel">Confirm</button>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function () {
populateTable1();
});


function populateTable1(){
    var customerId =4;  // Use the customer ID needed

    // Fetch orders for the specified customer
    $.ajax({
        url: 'http://localhost:8083/orders/customer/' + customerId,
        type: 'GET',
        dataType: 'json',
        success: function (orders) {
           if (orders && orders.length > 0) {
               orders.forEach(function (order) {
                   $('#ordersTableBody').append(`
                       <tr>
                           <td>`+order.id+`</td>
                           <td>`+order.createdAt+`</td>
                           <td>`+order.destination+`</td>
                           <td>`+order.status+`</td>
                           <td>
                               <a href="OrderTrackingController?orderId=${order.id}" class="btn btn-primary">View Order Details</a>
                               ${order.status == 'CANCELLED'
                                   ? '<button class="btn btn-cancelled" disabled>Cancelled</button>'
                                   : '<button class="btn btn-danger cancel-order" data-order-id="${order.id}">Cancel Order</button>'
                               }
                           </td>
                       </tr>`);
               });
           } else {
               $('#noOrdersMessage').show();  // Show message if no orders
               $('#ordersTable').hide();  // Hide the table
           }
       },
       error: function (xhr, status, error) {
           console.error("Error fetching orders:", error);
       }

    });

    // Add event listener for cancel buttons
    $(document).on('click', '.cancel-order', function () {
        const orderId = $(this).data('order-id');
        // Handle order cancellation here
        alert(`Cancel order functionality for order ID ${orderId} not yet implemented.`);
    });
}
</script>
<%@ include file="footer.jsp" %>