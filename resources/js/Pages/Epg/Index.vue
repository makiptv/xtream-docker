<script setup>
import { ref } from "vue";
import { Head, Link } from "@inertiajs/vue3";
import AppLayout from "@/Layouts/AppLayout.vue";
import Button from "@/Components/Button.vue";
import Badge from "@/Components/Badge.vue";

const props = defineProps({
    channels: Object,
    filters: Object,
});

const loading = ref(false);

const refreshEpg = async () => {
    loading.value = true;
    try {
        const response = await axios.post(route("epg.refresh"));
        toast.success("EPG data refreshed successfully");
    } catch (error) {
        toast.error("Failed to refresh EPG data");
    } finally {
        loading.value = false;
    }
};

const formatTime = (date) => {
    return new Date(date).toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
    });
};
</script>

<template>
    <AppLayout>
        <Head title="EPG" />

        <template #header>
            <div class="flex items-center justify-between">
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                    EPG
                </h2>

                <div class="flex items-center space-x-4">
                    <Button
                        variant="secondary"
                        size="sm"
                        :disabled="loading"
                        @click="refreshEpg"
                    >
                        <template v-if="loading">
                            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            Refreshing EPG...
                        </template>
                        <template v-else>
                            Refresh EPG
                        </template>
                    </Button>
                </div>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 bg-white border-b border-gray-200">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Channel
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Category
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Current Program
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Next Program
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <tr v-for="channel in channels.data" :key="channel.id">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10">
                                                    <img class="h-10 w-10 rounded-full" :src="channel.logo || '/default-channel.png'" :alt="channel.name">
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">
                                                        {{ channel.name }}
                                                    </div>
                                                    <div class="text-sm text-gray-500">
                                                        {{ channel.epg_channel_id || 'No EPG ID' }}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <Badge>{{ channel.category?.name || "Uncategorized" }}</Badge>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <template v-if="channel.epg_programs?.length">
                                                <div class="text-sm font-medium text-gray-900">
                                                    {{ channel.epg_programs[0].title }}
                                                </div>
                                                <div class="text-sm text-gray-500">
                                                    {{ formatTime(channel.epg_programs[0].start_time) }} - {{ formatTime(channel.epg_programs[0].end_time) }}
                                                </div>
                                            </template>
                                            <div v-else class="text-sm text-gray-500">
                                                No program data
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <template v-if="channel.epg_programs?.length > 1">
                                                <div class="text-sm font-medium text-gray-900">
                                                    {{ channel.epg_programs[1].title }}
                                                </div>
                                                <div class="text-sm text-gray-500">
                                                    {{ formatTime(channel.epg_programs[1].start_time) }} - {{ formatTime(channel.epg_programs[1].end_time) }}
                                                </div>
                                            </template>
                                            <div v-else class="text-sm text-gray-500">
                                                No program data
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <Link :href="`/epg/${channel.id}`" class="text-primary-600 hover:text-primary-900">
                                                View Schedule
                                            </Link>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="mt-4">
                            <div class="flex items-center justify-between">
                                <div class="flex-1 flex justify-between sm:hidden">
                                    <Link
                                        v-if="channels.prev_page_url"
                                        :href="channels.prev_page_url"
                                        class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                    >
                                        Previous
                                    </Link>
                                    <Link
                                        v-if="channels.next_page_url"
                                        :href="channels.next_page_url"
                                        class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                                    >
                                        Next
                                    </Link>
                                </div>
                                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                                    <div>
                                        <p class="text-sm text-gray-700">
                                            Showing
                                            <span class="font-medium">{{ channels.from }}</span>
                                            to
                                            <span class="font-medium">{{ channels.to }}</span>
                                            of
                                            <span class="font-medium">{{ channels.total }}</span>
                                            results
                                        </p>
                                    </div>
                                    <div>
                                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                            <Link
                                                v-if="channels.prev_page_url"
                                                :href="channels.prev_page_url"
                                                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                                            >
                                                <span class="sr-only">Previous</span>
                                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                                                </svg>
                                            </Link>

                                            <template v-for="(link, i) in channels.links.slice(1, -1)" :key="i">
                                                <Link
                                                    :href="link.url"
                                                    :class="[
                                                        link.active
                                                            ? 'z-10 bg-primary-50 border-primary-500 text-primary-600'
                                                            : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                                                        'relative inline-flex items-center px-4 py-2 border text-sm font-medium'
                                                    ]"
                                                >
                                                    {{ link.label }}
                                                </Link>
                                            </template>

                                            <Link
                                                v-if="channels.next_page_url"
                                                :href="channels.next_page_url"
                                                class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50"
                                            >
                                                <span class="sr-only">Next</span>
                                                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                                </svg>
                                            </Link>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>