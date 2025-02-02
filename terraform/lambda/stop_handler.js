exports.handler = async (event) => {
    const AWS = require('aws-sdk');
    const ec2 = new AWS.EC2();
    
    try {
        const instances = await ec2.describeInstances({
            Filters: [{
                Name: 'tag:AutoStop',
                Values: ['true']
            }]
        }).promise();
        
        const instanceIds = instances.Reservations
            .map(r => r.Instances)
            .flat()
            .map(i => i.InstanceId);
            
        if (instanceIds.length > 0) {
            await ec2.stopInstances({
                InstanceIds: instanceIds
            }).promise();
            
            console.log(`Stopped instances: ${instanceIds.join(', ')}`);
        }
        
        return {
            statusCode: 200,
            body: 'Successfully stopped instances'
        };
    } catch (error) {
        console.error('Error:', error);
        throw error;
    }
};